"""Offline tests for the report catalog and shared Python engine.

Author: Paul Bryant
"""

from __future__ import annotations

import csv
import sys
import tempfile
import types
import unittest
from pathlib import Path
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "_shared"))

from reporting import (  # noqa: E402
    _items, azure_resources, catalog, csv_cell, network_controller_resources,
    report_rows, write_csv,
)


class ReportTests(unittest.TestCase):
    def test_each_category_has_twenty_five_paired_reports(self) -> None:
        for category in (
            "azure-cloud", "azure-local", "azure-local-sdn-onprem",
            "azure-local-sdn-arc-enabled",
        ):
            with self.subTest(category=category):
                reports = catalog(category)["reports"]
                self.assertEqual(len(reports), 25)
                self.assertEqual(len({entry["id"] for entry in reports}), 25)
                self.assertEqual(len(list((ROOT / category / "python").glob("*.py"))), 25)
                self.assertEqual(len(list((ROOT / category / "powershell").glob("*.ps1"))), 25)
                for entry in reports:
                    self.assertTrue(entry["fields"])
                    self.assertEqual(len({field[0] for field in entry["fields"]}), len(entry["fields"]))
                    self.assertTrue(entry["docs"].startswith("https://learn.microsoft.com/"))

    def test_nested_expansion_and_filtering(self) -> None:
        spec = {
            "expand": "properties.securityRules",
            "filter": {"path": "item.properties.access", "op": "eq", "value": "Deny"},
            "fields": [["nsg", "name"], ["rule", "item.name"], ["access", "item.properties.access"]],
        }
        resources = [{"name": "nsg-one", "properties": {"securityRules": [
            {"name": "allow-web", "properties": {"access": "Allow"}},
            {"name": "deny-all", "properties": {"access": "Deny"}},
        ]}}]
        self.assertEqual(report_rows(resources, spec), [
            {"nsg": "nsg-one", "rule": "deny-all", "access": "Deny"}
        ])

    def test_empty_expansion_and_missing_filter(self) -> None:
        expanded = {"expand": "properties.ipConfigurations", "fields": [["ip", "item.properties.privateIPAddress"]]}
        self.assertEqual(report_rows([{"properties": {}}], expanded), [])
        missing = {"filter": {"path": "properties.networkSecurityGroup.id", "op": "missing"},
                   "fields": [["name", "name"]]}
        self.assertEqual(report_rows([{"name": "nic-1", "properties": {}}], missing), [{"name": "nic-1"}])

    def test_cluster_node_projection(self) -> None:
        spec = next(entry for entry in catalog("azure-local")["reports"] if entry["id"] == "cluster_nodes")
        resources = [{"name": "cluster-one", "properties": {"reportedProperties": {
            "nodes": [{"name": "node-one", "osVersion": "sample"}]
        }}}]
        rows = report_rows(resources, spec)
        self.assertEqual(rows[0]["node"]["name"], "node-one")

    def test_csv_has_headers_when_empty_and_escapes_formula(self) -> None:
        with tempfile.TemporaryDirectory(dir=ROOT / "tests") as folder:
            path = Path(folder) / "report.csv"
            fields = [["name", "name"], ["count", "count"]]
            write_csv([], fields, str(path))
            with path.open(encoding="utf-8-sig", newline="") as handle:
                self.assertEqual(list(csv.reader(handle)), [["name", "count"]])
            write_csv([{"name": "=HYPERLINK(\"x\")", "count": -1}], fields, str(path))
            with path.open(encoding="utf-8-sig", newline="") as handle:
                self.assertEqual(list(csv.DictReader(handle)), [{"name": "'=HYPERLINK(\"x\")", "count": "-1"}])
        self.assertEqual(csv_cell(["a", "b"]), '["a","b"]')

    def test_network_controller_collection_shapes(self) -> None:
        self.assertEqual(_items([{"resourceId": "a"}]), [{"resourceId": "a"}])
        self.assertEqual(_items([]), [])
        self.assertEqual(_items({"value": [{"resourceId": "b"}]}), [{"resourceId": "b"}])
        with self.assertRaises(ValueError):
            _items({"unexpected": True})

    def test_azure_resource_graph_continuation(self) -> None:
        calls = []

        class Response:
            status_code = 200
            headers = {}

            def __init__(self, data):
                self.data = data

            def raise_for_status(self):
                pass

            def json(self):
                return self.data

        class Session:
            def request(self, method, url, **kwargs):
                calls.append(kwargs["json"])
                if len(calls) == 1:
                    return Response({"data": [{"id": "one"}], "$skipToken": "next"})
                return Response({"data": [{"id": "two"}], "resultTruncated": False})

            def close(self):
                pass

        class Credential:
            def get_token(self, scope):
                return types.SimpleNamespace(token="test-token")

            def close(self):
                pass

        modules = {
            "requests": types.SimpleNamespace(Session=Session),
            "azure": types.ModuleType("azure"),
            "azure.identity": types.SimpleNamespace(DefaultAzureCredential=Credential),
        }
        with patch.dict(sys.modules, modules):
            rows = azure_resources("microsoft.compute/virtualmachines", ["sub-one"])
        self.assertEqual([row["id"] for row in rows], ["one", "two"])
        self.assertEqual(calls[1]["options"]["$skipToken"], "next")
        self.assertEqual(calls[0]["subscriptions"], ["sub-one"])

    def test_network_controller_child_collection(self) -> None:
        urls = []

        class Response:
            status_code = 200
            headers = {}

            def __init__(self, data):
                self.data = data

            def raise_for_status(self):
                pass

            def json(self):
                return self.data

        class Session:
            auth = None

            def request(self, method, url, **kwargs):
                urls.append(url)
                if len(urls) == 1:
                    return Response({"value": [{"resourceId": "parent-one"}]})
                return Response({"value": [{"resourceId": "child-one", "properties": {}}]})

            def close(self):
                pass

        modules = {
            "requests": types.SimpleNamespace(Session=Session),
            "requests_kerberos": types.SimpleNamespace(HTTPKerberosAuth=lambda: object()),
        }
        with patch.dict(sys.modules, modules):
            rows = network_controller_resources(
                {"source": "virtualNetworks", "child": "subnets"}, "https://nc.example.com"
            )
        self.assertEqual(rows[0]["_parentId"], "parent-one")
        self.assertEqual(urls[-1], "https://nc.example.com/networking/v1/virtualNetworks/parent-one/subnets")
        with self.assertRaises(ValueError):
            network_controller_resources({"source": "virtualNetworks"}, "http://nc.example.com")


if __name__ == "__main__":
    unittest.main()
