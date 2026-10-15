# Microsoft Infrastructure Reports

Author: Paul Bryant

This repository defines 100 read-only reports across four areas. Each report has a small PowerShell entry point and a small Python entry point, for 200 entry point files in total. The report definitions live in `tools/build_reports.py`; the shared request and CSV handling lives in `_shared`. The reports export selected inventory and configuration fields. They do not change infrastructure.

| Area | PowerShell | Python | Scope |
| --- | ---: | ---: | --- |
| [Azure Cloud](azure-cloud/README.md) | 25 | 25 | Azure Resource Manager resources across selected subscriptions |
| [Azure Local](azure-local/README.md) | 25 | 25 | Azure Local cluster, update, VM, image, storage and network resources |
| [Azure Local SDN managed on premises](azure-local-sdn-onprem/README.md) | 25 | 25 | Network Controller northbound REST resources |
| [Azure Local SDN enabled by Azure Arc](azure-local-sdn-arc-enabled/README.md) | 25 | 25 | Azure Local logical networks, interfaces, security groups and rules projected into Azure |

These are examples with offline checks. Paul Bryant no longer has a lab, so none of these scripts has been run against a live Azure subscription, Azure Local system or Network Controller. A successful local test does not establish version compatibility or production readiness. Some optional fields may be absent on a particular release. An empty CSV can mean no matching resources, insufficient read permissions, or resources that are not projected into Azure Resource Graph. Check the scope and permissions before interpreting an empty report.

Review the [per-report compatibility and source index](COMPATIBILITY.md), [fictional output examples and troubleshooting guide](EXAMPLES.md), and [version branch policy](VERSIONING.md) before use.

## Azure reports

The Azure Cloud, Azure Local and Arc-enabled SDN reports use [Azure Resource Graph](https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview). Resource Graph returns resources visible to the signed-in identity. Grant an appropriate read role on each subscription and use an identity that is allowed to query Resource Graph. Reports accept one or more subscription IDs and fetch all pages when the service provides a continuation token. The scripts stop if the service reports truncation without a token.

PowerShell requires PowerShell 7.4 or later, `Az.Accounts` and `Az.ResourceGraph`. Sign in with `Connect-AzAccount`, then run a report:

```powershell
./azure-cloud/powershell/Get-MsCloudVmInventory.ps1 -SubscriptionId '<subscription-id>' -OutputPath './vm-inventory.csv'
```

Python requires Python 3.11 or later and the packages in `requirements.txt`. Authenticate with a method supported by `DefaultAzureCredential`, such as `az login`, then run:

```text
python azure-cloud/python/get_vm_inventory.py --subscription <subscription-id> --output vm-inventory.csv
```

Repeat `--subscription` in Python or pass an array to `-SubscriptionId` in PowerShell to include more subscriptions. Use `--describe` or `-Describe` to inspect a report without connecting. If no output path is given, Python writes CSV to standard output and PowerShell emits objects to the pipeline.

Azure Resource Graph is an inventory service. It can lag resource changes and does not replace a live health check. The Azure Local reports are intended for the Azure Local 24H2/12.x generation; they do not assert that every projected property exists on every monthly release. The Arc-enabled SDN collection is organized around the management model documented for Azure Local 2506 or later. Logical networks and interfaces can exist without that feature, so these reports alone do not prove SDN enablement. Confirm the management model on the target instance. The on-premises SDN collection targets Network Controller deployments managed by local tools.

Arc-enabled SDN reports require the full Azure custom location resource ID to avoid mixing resources from different Azure Local instances:

```powershell
./azure-local-sdn-arc-enabled/powershell/Get-MsSdnArcLogicalNetworks.ps1 -SubscriptionId '<subscription-id>' -CustomLocation '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.ExtendedLocation/customLocations/<name>'
```

```text
python azure-local-sdn-arc-enabled/python/get_logical_networks.py --subscription <subscription-id> --custom-location '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.ExtendedLocation/customLocations/<name>'
```

The filter only selects resources under that custom location. It does not prove that Arc-enabled SDN is active there.

## On-premises SDN reports

Run these on a Windows system with a Kerberos identity authorized to read the Network Controller REST interface. The server must have a trusted HTTPS certificate and a resolvable hostname that matches its Kerberos service principal. The Python collection uses `requests-kerberos`; the PowerShell collection uses integrated credentials. Certificate-only client authentication is not implemented in this collection.

```powershell
./azure-local-sdn-onprem/powershell/Get-MsSdnOnpremLogicalNetworks.ps1 -ControllerUri 'https://nc.example.com' -OutputPath './logical-networks.csv'
```

```text
python azure-local-sdn-onprem/python/get_logical_networks.py --controller-uri https://nc.example.com --output logical-networks.csv
```

The Network Controller API paths come from Microsoft's [Northbound Interface protocol documentation](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140). Supported resources depend on the deployed Network Controller version and features. An unsupported endpoint or failed authentication causes an error instead of a fabricated empty report.

## Source and version notes

- [Azure Resource Graph query API and pagination](https://learn.microsoft.com/en-us/rest/api/azureresourcegraph/resourcegraph/resources/resources)
- [Azure Local resource type reference](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/allversions)
- [Azure Local release information](https://learn.microsoft.com/en-us/azure/azure-local/release-information-23h2)
- [SDN enabled by Azure Arc and on-premises SDN comparison](https://learn.microsoft.com/en-us/azure/azure-local/concepts/sdn-overview)
- [Network Controller northbound REST model](https://learn.microsoft.com/en-us/azure/azure-local/concepts/network-controller-overview)

The `reports.json` file in each area records the resource type or Network Controller endpoint and output fields for every report. The entry points share tested pagination, filtering and CSV logic in `_shared`. Run `python tools/build_reports.py` after editing the catalog source to regenerate the entry points and category indexes.

Use the [problem template](.github/ISSUE_TEMPLATE/report_problem.yml) for sanitized defects and version findings. Read [contribution terms](CONTRIBUTING.md) and [security reporting guidance](SECURITY.md) before submitting material.

Copyright (c) 2026 Paul Bryant. All rights reserved. See [copyright and reuse](COPYRIGHT.md).
