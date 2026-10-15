"""Read-only CSV reporting for Azure Resource Graph and Network Controller.

Author: Paul Bryant
"""

from __future__ import annotations

import argparse
import csv
import json
import sys
import time
from pathlib import Path
from typing import Any, Iterable
from urllib.parse import quote

ROOT = Path(__file__).resolve().parents[1]
ARG_URL = (
    "https://management.azure.com/providers/Microsoft.ResourceGraph/resources"
    "?api-version=2024-04-01"
)


def catalog(category: str) -> dict[str, Any]:
    path = ROOT / category / "reports.json"
    return json.loads(path.read_text(encoding="utf-8"))


def path_value(value: Any, path: str) -> Any:
    if not path:
        return value
    for part in path.split("."):
        if not isinstance(value, dict):
            return None
        value = value.get(part)
    return value


def field_value(resource: dict[str, Any], item: Any, path: str) -> Any:
    if path == "parentId":
        return resource.get("_parentId")
    if path == "item":
        return item
    if path.startswith("item."):
        return path_value(item, path[5:])
    return path_value(resource, path)


def matches(value: Any, condition: dict[str, Any] | None) -> bool:
    if not condition:
        return True
    op = condition["op"]
    expected = condition.get("value")
    values = value if isinstance(value, list) else [value]
    if op == "present":
        return any(v not in (None, "", [], {}) for v in values)
    if op == "missing":
        return all(v in (None, "", [], {}) for v in values)
    if op == "eq":
        return any(str(v).casefold() == str(expected).casefold() for v in values)
    if op == "ne":
        return all(str(v).casefold() != str(expected).casefold() for v in values)
    if op == "contains":
        return any(str(expected).casefold() in str(v).casefold() for v in values)
    raise ValueError(f"Unsupported report filter: {op}")


def report_rows(resources: Iterable[dict[str, Any]], spec: dict[str, Any]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for resource in resources:
        expanded = path_value(resource, spec["expand"]) if spec.get("expand") else [None]
        if expanded is None:
            expanded = []
        if not isinstance(expanded, list):
            expanded = [expanded]
        for item in expanded:
            condition = spec.get("filter")
            if condition and not matches(field_value(resource, item, condition["path"]), condition):
                continue
            rows.append({name: field_value(resource, item, path) for name, path in spec["fields"]})
    return rows


def _response_json(response: Any) -> dict[str, Any]:
    response.raise_for_status()
    result = response.json()
    if not isinstance(result, dict):
        raise ValueError("Expected a JSON object from Azure Resource Graph")
    return result


def _result_truncated(value: Any) -> bool:
    if value is None:
        return False
    if isinstance(value, bool):
        return value
    if isinstance(value, str) and value.casefold() in ("true", "false"):
        return value.casefold() == "true"
    raise ValueError("Azure Resource Graph returned an unexpected resultTruncated value")


def _request_with_retry(session: Any, method: str, url: str, **kwargs: Any) -> Any:
    for attempt in range(4):
        response = session.request(method, url, timeout=30, **kwargs)
        if response.status_code not in (429, 503) or attempt == 3:
            return response
        delay = response.headers.get("Retry-After", "2")
        try:
            seconds = min(max(int(delay), 1), 30)
        except ValueError:
            seconds = 2
        time.sleep(seconds)
    raise RuntimeError("Unreachable retry state")


def azure_resources(resource_type: str, subscriptions: list[str]) -> list[dict[str, Any]]:
    import requests
    from azure.identity import DefaultAzureCredential

    if not subscriptions:
        raise ValueError("At least one --subscription is required")
    credential = DefaultAzureCredential()
    session = requests.Session()
    query = f"Resources | where type =~ '{resource_type}' | order by id asc"
    rows: list[dict[str, Any]] = []
    token: str | None = None
    try:
        while True:
            options: dict[str, Any] = {"$top": 1000}
            if token:
                options["$skipToken"] = token
            bearer = credential.get_token("https://management.azure.com/.default").token
            response = _request_with_retry(
                session,
                "POST",
                ARG_URL,
                headers={"Authorization": f"Bearer {bearer}", "Content-Type": "application/json"},
                json={"subscriptions": subscriptions, "query": query, "options": options},
            )
            page = _response_json(response)
            data = page.get("data")
            if not isinstance(data, list):
                raise ValueError("Azure Resource Graph returned an unexpected data shape")
            rows.extend(data)
            token = page.get("$skipToken")
            if not token:
                if _result_truncated(page.get("resultTruncated")):
                    raise RuntimeError("Azure Resource Graph truncated results without a continuation token")
                break
    finally:
        session.close()
        credential.close()
    return rows


def _items(payload: Any) -> list[dict[str, Any]]:
    if isinstance(payload, list):
        return payload
    if isinstance(payload, dict):
        for key in ("value", "Value", "resources", "Resources"):
            if isinstance(payload.get(key), list):
                return payload[key]
        if payload.get("resourceId") or payload.get("id"):
            return [payload]
    raise ValueError("Network Controller returned an unexpected collection shape")


def network_controller_resources(spec: dict[str, Any], controller_uri: str) -> list[dict[str, Any]]:
    base = controller_uri.rstrip("/")
    if not base.startswith("https://"):
        raise ValueError("--controller-uri must use HTTPS")
    import requests
    from requests_kerberos import HTTPKerberosAuth

    session = requests.Session()
    session.auth = HTTPKerberosAuth()
    root = f"{base}/networking/v1/{spec['source']}"
    try:
        response = _request_with_retry(session, "GET", root)
        response.raise_for_status()
        parents = _items(response.json())
        if not spec.get("child"):
            return parents
        children: list[dict[str, Any]] = []
        for parent in parents:
            parent_id = parent.get("resourceId") or parent.get("id")
            if not parent_id:
                raise ValueError("Network Controller parent resource has no ID")
            parent_id = str(parent_id).rstrip("/").split("/")[-1]
            child_url = f"{root}/{quote(parent_id, safe='')}/{spec['child']}"
            child_response = _request_with_retry(session, "GET", child_url)
            child_response.raise_for_status()
            for child in _items(child_response.json()):
                child["_parentId"] = parent_id
                children.append(child)
        return children
    finally:
        session.close()


def csv_cell(value: Any) -> str:
    if value is None:
        return ""
    if isinstance(value, (dict, list)):
        value = json.dumps(value, ensure_ascii=False, separators=(",", ":"))
    text = str(value)
    if isinstance(value, str) and text.lstrip().startswith(("=", "+", "-", "@")):
        return "'" + text
    return text


def write_csv(rows: list[dict[str, Any]], fields: list[list[str]], output: str) -> None:
    columns = [name for name, _ in fields]
    if output == "-":
        handle = sys.stdout
        close = False
    else:
        target = Path(output).expanduser()
        target.parent.mkdir(parents=True, exist_ok=True)
        handle = target.open("w", encoding="utf-8-sig", newline="")
        close = True
    try:
        writer = csv.DictWriter(handle, fieldnames=columns, extrasaction="ignore")
        writer.writeheader()
        for row in rows:
            writer.writerow({key: csv_cell(value) for key, value in row.items()})
    finally:
        if close:
            handle.close()


def main(category: str, report: str) -> None:
    specs = catalog(category)
    spec = next((entry for entry in specs["reports"] if entry["id"] == report), None)
    if spec is None:
        raise SystemExit(f"Unknown report: {report}")
    parser = argparse.ArgumentParser(description=spec["description"])
    parser.add_argument("--describe", action="store_true", help="Show report details without connecting")
    parser.add_argument("--output", default="-", help="CSV path, or - for standard output")
    if specs["source"] == "arg":
        parser.add_argument("--subscription", action="append", default=[], help="Subscription ID; repeat for more")
    else:
        parser.add_argument("--controller-uri", help="HTTPS Network Controller REST address")
    args = parser.parse_args()
    if args.describe:
        print(json.dumps(spec, indent=2))
        return
    try:
        if specs["source"] == "arg":
            resources = azure_resources(spec["source_type"], args.subscription)
        else:
            if not args.controller_uri:
                parser.error("--controller-uri is required")
            resources = network_controller_resources(spec, args.controller_uri)
        rows = report_rows(resources, spec)
        write_csv(rows, spec["fields"], args.output)
    except Exception as exc:
        raise SystemExit(f"Report failed: {exc}") from exc


if __name__ == "__main__":
    raise SystemExit("Run a named report from one of the category folders")
