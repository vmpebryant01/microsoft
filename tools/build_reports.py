"""Build the report catalog and language entry points.

Author: Paul Bryant
"""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARG_DOC = "https://learn.microsoft.com/en-us/rest/api/azureresourcegraph/resourcegraph/resources/resources"
LOCAL_DOC = "https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/allversions"
CLUSTER_DOC = "https://learn.microsoft.com/en-us/rest/api/stackhci/clusters/get?view=rest-stackhci-2024-04-01"
ARC_DOC = "https://learn.microsoft.com/en-us/azure/azure-local/concepts/sdn-overview"
NC_DOC = "https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140"

COMMON_ARG = [["id", "id"], ["name", "name"], ["resourceGroup", "resourceGroup"], ["subscriptionId", "subscriptionId"]]
COMMON_NC = [["resourceId", "resourceId"], ["provisioningState", "properties.provisioningState"]]


def arg(name: str, description: str, source_type: str, *fields: tuple[str, str],
        expand: str | None = None, condition: tuple[str, str, str | None] | None = None,
        docs: str = ARG_DOC) -> dict:
    item = {"id": name, "description": description, "source_type": source_type.lower(),
            "fields": COMMON_ARG + [list(field) for field in fields], "docs": docs}
    if expand:
        item["expand"] = expand
    if condition:
        path, op, value = condition
        item["filter"] = {"path": path, "op": op}
        if value is not None:
            item["filter"]["value"] = value
    return item


def nc(name: str, description: str, source: str, *fields: tuple[str, str],
       child: str | None = None, condition: tuple[str, str, str | None] | None = None,
       docs: str = NC_DOC) -> dict:
    base = COMMON_NC + ([ ["parentId", "parentId"] ] if child else [])
    item = {"id": name, "description": description, "source": source,
            "fields": base + [list(field) for field in fields], "docs": docs}
    if child:
        item["child"] = child
    if condition:
        path, op, value = condition
        item["filter"] = {"path": path, "op": op}
        if value is not None:
            item["filter"]["value"] = value
    return item


CLOUD = [
    arg("vm_inventory", "Inventory virtual machines and their hardware size.", "microsoft.compute/virtualmachines", ("location", "location"), ("vmSize", "properties.hardwareProfile.vmSize"), ("provisioningState", "properties.provisioningState")),
    arg("vm_images", "Report VM image references and operating system types.", "microsoft.compute/virtualmachines", ("osType", "properties.storageProfile.osDisk.osType"), ("publisher", "properties.storageProfile.imageReference.publisher"), ("offer", "properties.storageProfile.imageReference.offer"), ("sku", "properties.storageProfile.imageReference.sku")),
    arg("vm_os_disks", "Report operating system disks attached to VMs.", "microsoft.compute/virtualmachines", ("diskName", "properties.storageProfile.osDisk.name"), ("managedDiskId", "properties.storageProfile.osDisk.managedDisk.id"), ("caching", "properties.storageProfile.osDisk.caching")),
    arg("vm_data_disks", "Report every VM data disk reference.", "microsoft.compute/virtualmachines", ("lun", "item.lun"), ("diskName", "item.name"), ("managedDiskId", "item.managedDisk.id"), expand="properties.storageProfile.dataDisks"),
    arg("vm_network_interfaces", "Report VM network interface references.", "microsoft.compute/virtualmachines", ("nicId", "item.id"), ("primary", "item.properties.primary"), expand="properties.networkProfile.networkInterfaces"),
    arg("managed_disks", "Inventory managed disks and their sizes.", "microsoft.compute/disks", ("location", "location"), ("diskSizeGB", "properties.diskSizeGB"), ("diskState", "properties.diskState"), ("sku", "sku.name")),
    arg("unattached_disks", "Find managed disks reported as unattached.", "microsoft.compute/disks", ("diskSizeGB", "properties.diskSizeGB"), ("sku", "sku.name"), condition=("properties.diskState", "eq", "Unattached")),
    arg("disk_encryption", "Report managed disk encryption settings.", "microsoft.compute/disks", ("encryptionType", "properties.encryption.type"), ("diskEncryptionSetId", "properties.encryption.diskEncryptionSetId"), ("securityType", "properties.securityProfile.securityType")),
    arg("snapshots", "Inventory managed disk snapshots.", "microsoft.compute/snapshots", ("location", "location"), ("diskSizeGB", "properties.diskSizeGB"), ("sourceId", "properties.creationData.sourceResourceId")),
    arg("vm_scale_sets", "Inventory virtual machine scale sets and planned capacity.", "microsoft.compute/virtualmachinescalesets", ("location", "location"), ("capacity", "sku.capacity"), ("vmSize", "sku.name")),
    arg("availability_sets", "Inventory availability sets and fault domain settings.", "microsoft.compute/availabilitysets", ("faultDomains", "properties.platformFaultDomainCount"), ("updateDomains", "properties.platformUpdateDomainCount")),
    arg("virtual_networks", "Inventory Azure virtual networks and address spaces.", "microsoft.network/virtualnetworks", ("location", "location"), ("addressPrefixes", "properties.addressSpace.addressPrefixes"), ("provisioningState", "properties.provisioningState")),
    arg("subnets", "Report embedded subnet definitions in virtual networks.", "microsoft.network/virtualnetworks", ("subnetName", "item.name"), ("addressPrefix", "item.properties.addressPrefix"), ("addressPrefixes", "item.properties.addressPrefixes"), expand="properties.subnets"),
    arg("vnet_peerings", "Report virtual network peering relationships.", "microsoft.network/virtualnetworks", ("peeringName", "item.name"), ("remoteVnet", "item.properties.remoteVirtualNetwork.id"), ("peeringState", "item.properties.peeringState"), expand="properties.virtualNetworkPeerings"),
    arg("network_security_groups", "Inventory Azure network security groups.", "microsoft.network/networksecuritygroups", ("location", "location"), ("provisioningState", "properties.provisioningState"), ("nicReferences", "properties.networkInterfaces")),
    arg("nsg_rules", "Report custom Azure network security rules.", "microsoft.network/networksecuritygroups", ("ruleName", "item.name"), ("direction", "item.properties.direction"), ("access", "item.properties.access"), ("priority", "item.properties.priority"), expand="properties.securityRules"),
    arg("route_tables", "Inventory route tables and BGP propagation settings.", "microsoft.network/routetables", ("location", "location"), ("disableBgpPropagation", "properties.disableBgpRoutePropagation")),
    arg("routes", "Report routes embedded in Azure route tables.", "microsoft.network/routetables", ("routeName", "item.name"), ("addressPrefix", "item.properties.addressPrefix"), ("nextHopType", "item.properties.nextHopType"), ("nextHopIpAddress", "item.properties.nextHopIpAddress"), expand="properties.routes"),
    arg("public_ips", "Inventory Azure public IP addresses.", "microsoft.network/publicipaddresses", ("location", "location"), ("ipAddress", "properties.ipAddress"), ("allocationMethod", "properties.publicIPAllocationMethod"), ("sku", "sku.name")),
    arg("load_balancers", "Inventory Azure load balancers and SKU.", "microsoft.network/loadbalancers", ("location", "location"), ("sku", "sku.name"), ("frontendConfigurations", "properties.frontendIPConfigurations")),
    arg("storage_accounts", "Inventory Azure storage accounts and network defaults.", "microsoft.storage/storageaccounts", ("location", "location"), ("sku", "sku.name"), ("kind", "kind"), ("defaultAction", "properties.networkAcls.defaultAction")),
    arg("key_vaults", "Inventory Key Vault resources and access model.", "microsoft.keyvault/vaults", ("location", "location"), ("enableRbacAuthorization", "properties.enableRbacAuthorization"), ("publicNetworkAccess", "properties.publicNetworkAccess")),
    arg("sql_servers", "Inventory Azure SQL logical servers.", "microsoft.sql/servers", ("location", "location"), ("version", "properties.version"), ("administratorLogin", "properties.administratorLogin")),
    arg("sql_databases", "Inventory Azure SQL databases and service tiers.", "microsoft.sql/servers/databases", ("location", "location"), ("status", "properties.status"), ("sku", "sku.name")),
    arg("app_services", "Inventory App Service applications and runtime state.", "microsoft.web/sites", ("location", "location"), ("state", "properties.state"), ("kind", "kind"), ("httpsOnly", "properties.httpsOnly")),
]

L = "microsoft.azurestackhci/"
LOCAL = [
    arg("clusters", "Inventory Azure Local cluster resources.", L + "clusters", ("location", "location"), ("provisioningState", "properties.provisioningState"), docs=LOCAL_DOC),
    arg("cluster_versions", "Report Azure Local cluster software and hardware versions.", L + "clusters", ("clusterVersion", "properties.reportedProperties.clusterVersion"), ("nodeType", "properties.reportedProperties.clusterType"), ("cloudId", "properties.cloudId"), docs=CLUSTER_DOC),
    arg("cluster_connectivity", "Report registration and connectivity fields for clusters.", L + "clusters", ("registrationTimestamp", "properties.registrationTimestamp"), ("connectivityStatus", "properties.connectivityStatus"), ("lastSyncTimestamp", "properties.lastSyncTimestamp"), docs=CLUSTER_DOC),
    arg("cluster_tags", "Report tags applied to Azure Local clusters.", L + "clusters", ("tags", "tags"), docs=LOCAL_DOC),
    arg("cluster_nodes", "Report node entries exposed by cluster resources.", L + "clusters", ("node", "item"), expand="properties.reportedProperties.nodes", docs=CLUSTER_DOC),
    arg("arc_settings", "Inventory cluster Arc settings.", L + "clusters/arcsettings", ("provisioningState", "properties.provisioningState"), ("arcInstanceResourceGroup", "properties.arcInstanceResourceGroup"), docs=LOCAL_DOC),
    arg("arc_extensions", "Inventory Azure Local Arc extensions.", L + "clusters/arcsettings/extensions", ("publisher", "properties.publisher"), ("type", "properties.type"), ("typeHandlerVersion", "properties.typeHandlerVersion"), ("provisioningState", "properties.provisioningState"), docs=LOCAL_DOC),
    arg("deployment_settings", "Inventory Azure Local deployment settings resources.", L + "clusters/deploymentsettings", ("provisioningState", "properties.provisioningState"), ("deploymentMode", "properties.deploymentMode"), docs=LOCAL_DOC),
    arg("security_settings", "Report cluster security settings resources.", L + "clusters/securitysettings", ("provisioningState", "properties.provisioningState"), ("securityComplianceStatus", "properties.securityComplianceStatus"), docs=LOCAL_DOC),
    arg("update_summaries", "Report cluster update summaries.", L + "clusters/updatesummaries", ("state", "properties.state"), ("lastUpdated", "properties.lastUpdated"), docs=LOCAL_DOC),
    arg("available_updates", "Inventory available cluster updates.", L + "clusters/updates", ("state", "properties.state"), ("version", "properties.version"), docs=LOCAL_DOC),
    arg("update_runs", "Report Azure Local cluster update runs.", L + "clusters/updates/updateruns", ("state", "properties.state"), ("startTimeUtc", "properties.startTimeUtc"), ("endTimeUtc", "properties.endTimeUtc"), docs=LOCAL_DOC),
    arg("edge_devices", "Inventory registered Azure Local edge devices.", L + "edgedevices", ("provisioningState", "properties.provisioningState"), ("deviceType", "properties.deviceType"), docs=LOCAL_DOC),
    arg("gallery_images", "Inventory Azure Local gallery images.", L + "galleryimages", ("location", "location"), ("osType", "properties.osType"), docs=LOCAL_DOC),
    arg("marketplace_images", "Inventory Azure Local marketplace gallery images.", L + "marketplacegalleryimages", ("location", "location"), ("osType", "properties.osType"), docs=LOCAL_DOC),
    arg("logical_networks", "Inventory Azure Local logical networks.", L + "logicalnetworks", ("subnets", "properties.subnets"), ("vmSwitchName", "properties.vmSwitchName"), docs=LOCAL_DOC),
    arg("network_interfaces", "Inventory Azure Local network interfaces.", L + "networkinterfaces", ("ipConfigurations", "properties.ipConfigurations"), ("provisioningState", "properties.provisioningState"), docs=LOCAL_DOC),
    arg("storage_containers", "Inventory Azure Local storage containers.", L + "storagecontainers", ("path", "properties.path"), ("provisioningState", "properties.provisioningState"), docs=LOCAL_DOC),
    arg("virtual_hard_disks", "Inventory Azure Local virtual hard disks.", L + "virtualharddisks", ("diskSizeGB", "properties.diskSizeGB"), ("provisioningState", "properties.provisioningState"), docs=LOCAL_DOC),
    arg("vm_instances", "Inventory Azure Local virtual machine instances.", L + "virtualmachineinstances", ("location", "location"), ("provisioningState", "properties.provisioningState"), ("status", "properties.status"), docs=LOCAL_DOC),
    arg("vm_hardware", "Report Azure Local VM hardware profiles.", L + "virtualmachineinstances", ("processors", "properties.hardwareProfile.processors"), ("memoryMB", "properties.hardwareProfile.memoryMB"), ("vmSize", "properties.hardwareProfile.vmSize"), docs=LOCAL_DOC),
    arg("vm_disks", "Report data disk references on Azure Local VMs.", L + "virtualmachineinstances", ("disk", "item"), expand="properties.storageProfile.dataDisks", docs=LOCAL_DOC),
    arg("vm_network_adapters", "Report network interface references on Azure Local VMs.", L + "virtualmachineinstances", ("networkInterface", "item"), expand="properties.networkProfile.networkInterfaces", docs=LOCAL_DOC),
    arg("guest_agents", "Inventory Azure Local VM guest agent resources.", L + "virtualmachineinstances/guestagents", ("provisioningState", "properties.provisioningState"), ("status", "properties.status"), docs=LOCAL_DOC),
    arg("hybrid_identity", "Inventory Azure Local VM hybrid identity metadata.", L + "virtualmachineinstances/hybrididentitymetadata", ("provisioningState", "properties.provisioningState"), ("identity", "properties.identity"), docs=LOCAL_DOC),
]

ARC = [
    arg("logical_networks", "Inventory Azure Local logical networks projected into Azure.", L + "logicalnetworks", ("location", "location"), ("customLocation", "extendedLocation.name"), ("provisioningState", "properties.provisioningState"), docs=ARC_DOC),
    arg("logical_network_addressing", "Report logical network subnets and DNS settings.", L + "logicalnetworks", ("subnets", "properties.subnets"), ("dnsServers", "properties.dhcpOptions.dnsServers"), docs=ARC_DOC),
    arg("logical_network_vlans", "Report VLAN identifiers on Azure Local logical network subnets.", L + "logicalnetworks", ("subnetName", "item.name"), ("vlan", "item.properties.vlan"), ("addressPrefix", "item.properties.addressPrefix"), expand="properties.subnets", docs=ARC_DOC),
    arg("logical_network_subnets", "Report subnet definitions within Azure Local logical networks.", L + "logicalnetworks", ("subnet", "item"), expand="properties.subnets", docs=ARC_DOC),
    arg("logical_network_ip_pools", "Report IP pools by Azure Local logical network subnet.", L + "logicalnetworks", ("subnetName", "item.name"), ("ipPools", "item.properties.ipPools"), expand="properties.subnets", docs=ARC_DOC),
    arg("logical_network_custom_locations", "Map Azure Local logical networks to custom locations.", L + "logicalnetworks", ("customLocation", "extendedLocation.name"), ("vmSwitchName", "properties.vmSwitchName"), docs=ARC_DOC),
    arg("logical_network_not_succeeded", "Find logical networks without a Succeeded provisioning state.", L + "logicalnetworks", ("provisioningState", "properties.provisioningState"), condition=("properties.provisioningState", "ne", "Succeeded"), docs=ARC_DOC),
    arg("network_interfaces", "Inventory Azure Local network interfaces projected into Azure.", L + "networkinterfaces", ("location", "location"), ("customLocation", "extendedLocation.name"), ("provisioningState", "properties.provisioningState"), docs=ARC_DOC),
    arg("nic_ip_configurations", "Report Azure Local network interface IP configurations.", L + "networkinterfaces", ("ipConfiguration", "item"), expand="properties.ipConfigurations", docs=ARC_DOC),
    arg("nic_private_ips", "Report private IP addresses assigned to Azure Local interfaces.", L + "networkinterfaces", ("privateIpAddress", "item.properties.privateIPAddress"), ("subnetId", "item.properties.subnet.id"), expand="properties.ipConfigurations", docs=ARC_DOC),
    arg("nic_security_groups", "Report security group references on Azure Local interfaces.", L + "networkinterfaces", ("nsgId", "properties.networkSecurityGroup.id"), docs=ARC_DOC),
    arg("nic_without_security_group", "Find Azure Local interfaces without an NSG reference.", L + "networkinterfaces", ("customLocation", "extendedLocation.name"), condition=("properties.networkSecurityGroup.id", "missing", None), docs=ARC_DOC),
    arg("nic_not_succeeded", "Find Azure Local interfaces without a Succeeded provisioning state.", L + "networkinterfaces", ("provisioningState", "properties.provisioningState"), condition=("properties.provisioningState", "ne", "Succeeded"), docs=ARC_DOC),
    arg("security_groups", "Inventory Azure Local network security groups.", L + "networksecuritygroups", ("customLocation", "extendedLocation.name"), ("provisioningState", "properties.provisioningState"), docs=ARC_DOC),
    arg("nsg_network_interfaces", "Report interfaces associated with Azure Local NSGs.", L + "networksecuritygroups", ("networkInterface", "item.id"), expand="properties.networkInterfaces", docs=ARC_DOC),
    arg("nsg_subnets", "Report logical network subnets associated with NSGs.", L + "networksecuritygroups", ("subnet", "item.id"), expand="properties.subnets", docs=ARC_DOC),
    arg("nsg_not_succeeded", "Find Azure Local NSGs without a Succeeded provisioning state.", L + "networksecuritygroups", ("provisioningState", "properties.provisioningState"), condition=("properties.provisioningState", "ne", "Succeeded"), docs=ARC_DOC),
    arg("security_rules", "Inventory Azure Local SDN security rules.", L + "networksecuritygroups/securityrules", ("direction", "properties.direction"), ("access", "properties.access"), ("priority", "properties.priority"), docs=ARC_DOC),
    arg("inbound_rules", "Report inbound Azure Local SDN security rules.", L + "networksecuritygroups/securityrules", ("access", "properties.access"), ("protocol", "properties.protocol"), ("priority", "properties.priority"), condition=("properties.direction", "eq", "Inbound"), docs=ARC_DOC),
    arg("outbound_rules", "Report outbound Azure Local SDN security rules.", L + "networksecuritygroups/securityrules", ("access", "properties.access"), ("protocol", "properties.protocol"), ("priority", "properties.priority"), condition=("properties.direction", "eq", "Outbound"), docs=ARC_DOC),
    arg("allow_rules", "Report Azure Local SDN rules that allow traffic.", L + "networksecuritygroups/securityrules", ("direction", "properties.direction"), ("sourcePrefixes", "properties.sourceAddressPrefixes"), ("destinationPorts", "properties.destinationPortRanges"), condition=("properties.access", "eq", "Allow"), docs=ARC_DOC),
    arg("deny_rules", "Report Azure Local SDN rules that deny traffic.", L + "networksecuritygroups/securityrules", ("direction", "properties.direction"), ("sourcePrefixes", "properties.sourceAddressPrefixes"), ("destinationPorts", "properties.destinationPortRanges"), condition=("properties.access", "eq", "Deny"), docs=ARC_DOC),
    arg("rule_sources", "Report source prefixes and ports for Azure Local rules.", L + "networksecuritygroups/securityrules", ("sourcePrefixes", "properties.sourceAddressPrefixes"), ("sourcePorts", "properties.sourcePortRanges"), ("direction", "properties.direction"), docs=ARC_DOC),
    arg("rule_destinations", "Report destination prefixes and ports for Azure Local rules.", L + "networksecuritygroups/securityrules", ("destinationPrefixes", "properties.destinationAddressPrefixes"), ("destinationPorts", "properties.destinationPortRanges"), ("direction", "properties.direction"), docs=ARC_DOC),
    arg("rule_protocols", "Report protocol, priority and access for Azure Local rules.", L + "networksecuritygroups/securityrules", ("protocol", "properties.protocol"), ("priority", "properties.priority"), ("access", "properties.access"), docs=ARC_DOC),
]

NC = [
    nc("logical_networks", "Inventory Network Controller logical networks.", "logicalNetworks", ("subnets", "properties.subnets"), ("networkVirtualizationEnabled", "properties.networkVirtualizationEnabled")),
    nc("logical_subnets", "Report logical subnets and VLANs.", "logicalNetworks", ("addressPrefix", "properties.addressPrefix"), ("vlanId", "properties.vlanId"), child="subnets"),
    nc("virtual_networks", "Inventory tenant virtual networks.", "virtualNetworks", ("addressSpace", "properties.addressSpace"), ("logicalNetwork", "properties.logicalNetwork")),
    nc("virtual_subnets", "Report tenant virtual network subnets.", "virtualNetworks", ("addressPrefix", "properties.addressPrefix"), ("accessControlList", "properties.accessControlList"), child="subnets"),
    nc("network_interfaces", "Inventory Network Controller network interfaces.", "networkInterfaces", ("privateMacAddress", "properties.privateMacAddress"), ("server", "properties.server")),
    nc("nic_ip_configurations", "Report Network Controller NIC IP configurations.", "networkInterfaces", ("privateIPAddress", "properties.privateIPAddress"), ("subnet", "properties.subnet"), child="ipConfigurations"),
    nc("access_control_lists", "Inventory SDN access control lists.", "accessControlLists", ("rules", "properties.aclRules")),
    nc("acl_rules", "Report SDN ACL rules.", "accessControlLists", ("action", "properties.action"), ("priority", "properties.priority"), ("direction", "properties.type"), child="aclRules"),
    nc("acl_allow_rules", "Report SDN ACL rules that allow traffic.", "accessControlLists", ("priority", "properties.priority"), ("protocol", "properties.protocol"), child="aclRules", condition=("properties.action", "eq", "Allow")),
    nc("acl_deny_rules", "Report SDN ACL rules that deny traffic.", "accessControlLists", ("priority", "properties.priority"), ("protocol", "properties.protocol"), child="aclRules", condition=("properties.action", "eq", "Deny")),
    nc("route_tables", "Inventory tenant route tables.", "routeTables", ("routes", "properties.routes")),
    nc("routes", "Report tenant route prefixes and next hops.", "routeTables", ("addressPrefix", "properties.addressPrefix"), ("nextHopType", "properties.nextHopType"), ("nextHopIpAddress", "properties.nextHopIpAddress"), child="routes"),
    nc("load_balancers", "Inventory SDN load balancers.", "loadBalancers", ("frontends", "properties.frontendIPConfigurations")),
    nc("lb_frontends", "Report load balancer frontend IP configurations.", "loadBalancers", ("privateIPAddress", "properties.privateIPAddress"), ("publicIPAddress", "properties.publicIPAddress"), child="frontendIPConfigurations"),
    nc("lb_backends", "Report load balancer backend address pools.", "loadBalancers", ("backendIPConfigurations", "properties.backendIPConfigurations"), child="backendAddressPools"),
    nc("lb_probes", "Report load balancer health probe settings.", "loadBalancers", ("protocol", "properties.protocol"), ("port", "properties.port"), ("intervalSeconds", "properties.intervalInSeconds"), child="probes"),
    nc("lb_rules", "Report load balancing rules and port mappings.", "loadBalancers", ("protocol", "properties.protocol"), ("frontendPort", "properties.frontendPort"), ("backendPort", "properties.backendPort"), child="loadBalancingRules"),
    nc("lb_inbound_nat", "Report load balancer inbound NAT rules.", "loadBalancers", ("frontendPort", "properties.frontendPort"), ("backendPort", "properties.backendPort"), child="inboundNatRules"),
    nc("lb_outbound_nat", "Report load balancer outbound NAT rules.", "loadBalancers", ("backendAddressPool", "properties.backendAddressPool"), child="outboundNatRules"),
    nc("public_ips", "Inventory Network Controller public IP resources.", "publicIPAddresses", ("ipAddress", "properties.ipAddress"), ("ipConfiguration", "properties.ipConfiguration")),
    nc("gateways", "Inventory SDN gateway virtual machines.", "gateways", ("gatewayPools", "properties.gatewayPools"), ("virtualServer", "properties.virtualServer")),
    nc("gateway_pools", "Inventory gateway pools and capacity.", "GatewayPools", ("capacity", "properties.capacity"), ("gateways", "properties.gateways")),
    nc("virtual_gateways", "Inventory tenant virtual gateways.", "VirtualGateways", ("gatewayPool", "properties.gatewayPool"), ("bgpRouters", "properties.bgpRouters")),
    nc("gateway_connections", "Report tenant virtual gateway network connections.", "VirtualGateways", ("connectionType", "properties.connectionType"), ("outboundKbps", "properties.outboundKiloBitsPerSecond"), child="networkConnections"),
    nc("servers", "Inventory Network Controller managed servers.", "servers", ("managementAddresses", "properties.managementAddresses"), ("networkInterfaces", "properties.networkInterfaces")),
]

CATEGORIES = {
    "azure-cloud": ("Azure Cloud", "MsCloud", CLOUD, "arg"),
    "azure-local": ("Azure Local", "MsLocal", LOCAL, "arg"),
    "azure-local-sdn-onprem": ("Azure Local SDN managed on premises", "MsSdnOnprem", NC, "nc"),
    "azure-local-sdn-arc-enabled": ("Azure Local SDN enabled by Azure Arc", "MsSdnArc", ARC, "arg"),
}


def script_name(report_id: str) -> str:
    return "".join(part.capitalize() for part in report_id.split("_"))


def build() -> None:
    for category, (title, prefix, reports, source) in CATEGORIES.items():
        if len(reports) != 25:
            raise ValueError(f"{category} contains {len(reports)} reports, expected 25")
        if len({report["id"] for report in reports}) != 25:
            raise ValueError(f"Duplicate report IDs in {category}")
        directory = ROOT / category
        (directory / "powershell").mkdir(parents=True, exist_ok=True)
        (directory / "python").mkdir(parents=True, exist_ok=True)
        (directory / "reports.json").write_text(
            json.dumps({"author": "Paul Bryant", "category": category, "source": source, "reports": reports}, indent=2) + "\n",
            encoding="utf-8",
        )
        lines = [f"# {title}", "", "Author: Paul Bryant", "", "Each report is available in PowerShell and Python. All reports read configuration only and export selected fields. Live behavior has not been validated.", ""]
        if category == "azure-local-sdn-arc-enabled":
            lines.extend(["These reports inspect Azure Local network resources used with the Arc-enabled SDN management model. Logical networks and interfaces can also exist without SDN enabled by Arc. The resource type alone does not establish the management model. Confirm SDN enablement on the target Azure Local instance before interpreting these reports as an Arc-enabled SDN inventory.", ""])
        lines.extend(["| Report | PowerShell | Python |", "| --- | --- | --- |"])
        for report in reports:
            name = script_name(report["id"])
            ps_name = f"Get-{prefix}{name}.ps1"
            py_name = f"get_{report['id']}.py"
            if source == "arg":
                ps_params = "[string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe"
                ps_call = f"Invoke-Report -Category '{category}' -ReportId '{report['id']}' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe"
            else:
                ps_params = "[string]$ControllerUri, [string]$OutputPath, [switch]$Describe"
                ps_call = f"Invoke-Report -Category '{category}' -ReportId '{report['id']}' -ControllerUri $ControllerUri -OutputPath $OutputPath -Describe:$Describe"
            ps_content = (
                f"# {report['description']}\n# Author: Paul Bryant\n"
                f"param({ps_params})\n"
                ". (Join-Path $PSScriptRoot '..\\..\\_shared\\ReportEngine.ps1')\n"
                f"{ps_call}\n"
            )
            py_content = (
                f'"""{report["description"]} Author: Paul Bryant."""\n\n'
                "from pathlib import Path\nimport sys\n\n"
                "sys.path.insert(0, str(Path(__file__).resolve().parents[2] / '_shared'))\n"
                "from reporting import main\n\n"
                "if __name__ == '__main__':\n"
                f"    main('{category}', '{report['id']}')\n"
            )
            (directory / "powershell" / ps_name).write_text(ps_content, encoding="utf-8")
            (directory / "python" / py_name).write_text(py_content, encoding="utf-8")
            lines.append(f"| {report['description']} | [PowerShell](powershell/{ps_name}) | [Python](python/{py_name}) |")
        lines.extend(["", "See the [repository guide](../README.md) for setup, credentials, scope and known limits.", ""])
        (directory / "README.md").write_text("\n".join(lines), encoding="utf-8")


if __name__ == "__main__":
    build()
