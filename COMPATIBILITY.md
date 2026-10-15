# Report compatibility and evidence

Author: Paul Bryant

All 100 report definitions have offline syntax, catalog, and entry point description checks. A smaller set has fictional projection fixtures. None has been run against a live Azure subscription, Azure Local system, or Network Controller. A linked schema documents a resource type or protocol, but does not prove that Azure Resource Graph projects every listed field or that a deployed version supports the endpoint.

The Azure reports query Azure Resource Graph REST API `2024-04-01` in Python or the installed `Az.ResourceGraph` module in PowerShell. They do not pin the underlying resource provider schema version. The on-premises SDN reports call Network Controller `/networking/v1`.

| Collection | Intended product family | Evidence |
| --- | --- | --- |
| Azure Cloud | Rolling Azure services | [Resource Graph query API](https://learn.microsoft.com/en-us/rest/api/azureresourcegraph/resourcegraph/resources/resources) |
| Azure Local | Azure Local 24H2 / 12.x target | [Azure Local release information](https://learn.microsoft.com/en-us/azure/azure-local/release-information-23h2) |
| Azure Local SDN on premises | Azure Local 2311.2 or later, or Windows Server SDN | [SDN management overview](https://learn.microsoft.com/en-us/azure/azure-local/concepts/sdn-overview) |
| Azure Local SDN enabled by Arc | Azure Local 2506 or later with OS build 26100.xxxx | [SDN management overview](https://learn.microsoft.com/en-us/azure/azure-local/concepts/sdn-overview) |

Each entry below is **unverified in a live environment**. `ARG` means the Resource Graph query API above, and `NC` means the Network Controller protocol. The schema link points to Microsoft documentation for the resource type or endpoint family. Check the schema for the target deployment before relying on a report.

## Azure Cloud

| Report | Source and API | Microsoft reference |
| --- | --- | --- |
| [`vm_inventory`](azure-cloud/python/get_vm_inventory.py) | `ARG: microsoft.compute/virtualmachines` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines) |
| [`vm_images`](azure-cloud/python/get_vm_images.py) | `ARG: microsoft.compute/virtualmachines` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines) |
| [`vm_os_disks`](azure-cloud/python/get_vm_os_disks.py) | `ARG: microsoft.compute/virtualmachines` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines) |
| [`vm_data_disks`](azure-cloud/python/get_vm_data_disks.py) | `ARG: microsoft.compute/virtualmachines` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines) |
| [`vm_network_interfaces`](azure-cloud/python/get_vm_network_interfaces.py) | `ARG: microsoft.compute/virtualmachines` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines) |
| [`managed_disks`](azure-cloud/python/get_managed_disks.py) | `ARG: microsoft.compute/disks` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/disks) |
| [`unattached_disks`](azure-cloud/python/get_unattached_disks.py) | `ARG: microsoft.compute/disks` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/disks) |
| [`disk_encryption`](azure-cloud/python/get_disk_encryption.py) | `ARG: microsoft.compute/disks` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/disks) |
| [`snapshots`](azure-cloud/python/get_snapshots.py) | `ARG: microsoft.compute/snapshots` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/snapshots) |
| [`vm_scale_sets`](azure-cloud/python/get_vm_scale_sets.py) | `ARG: microsoft.compute/virtualmachinescalesets` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachinescalesets) |
| [`availability_sets`](azure-cloud/python/get_availability_sets.py) | `ARG: microsoft.compute/availabilitysets` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/availabilitysets) |
| [`virtual_networks`](azure-cloud/python/get_virtual_networks.py) | `ARG: microsoft.network/virtualnetworks` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks) |
| [`subnets`](azure-cloud/python/get_subnets.py) | `ARG: microsoft.network/virtualnetworks` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks) |
| [`vnet_peerings`](azure-cloud/python/get_vnet_peerings.py) | `ARG: microsoft.network/virtualnetworks` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks) |
| [`network_security_groups`](azure-cloud/python/get_network_security_groups.py) | `ARG: microsoft.network/networksecuritygroups` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/networksecuritygroups) |
| [`nsg_rules`](azure-cloud/python/get_nsg_rules.py) | `ARG: microsoft.network/networksecuritygroups` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/networksecuritygroups) |
| [`route_tables`](azure-cloud/python/get_route_tables.py) | `ARG: microsoft.network/routetables` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/routetables) |
| [`routes`](azure-cloud/python/get_routes.py) | `ARG: microsoft.network/routetables` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/routetables) |
| [`public_ips`](azure-cloud/python/get_public_ips.py) | `ARG: microsoft.network/publicipaddresses` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/publicipaddresses) |
| [`load_balancers`](azure-cloud/python/get_load_balancers.py) | `ARG: microsoft.network/loadbalancers` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/loadbalancers) |
| [`storage_accounts`](azure-cloud/python/get_storage_accounts.py) | `ARG: microsoft.storage/storageaccounts` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts) |
| [`key_vaults`](azure-cloud/python/get_key_vaults.py) | `ARG: microsoft.keyvault/vaults` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults) |
| [`sql_servers`](azure-cloud/python/get_sql_servers.py) | `ARG: microsoft.sql/servers` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers) |
| [`sql_databases`](azure-cloud/python/get_sql_databases.py) | `ARG: microsoft.sql/servers/databases` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers/databases) |
| [`app_services`](azure-cloud/python/get_app_services.py) | `ARG: microsoft.web/sites` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.web/sites) |

## Azure Local

| Report | Source and API | Microsoft reference |
| --- | --- | --- |
| [`clusters`](azure-local/python/get_clusters.py) | `ARG: microsoft.azurestackhci/clusters` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/clusters) |
| [`cluster_versions`](azure-local/python/get_cluster_versions.py) | `ARG: microsoft.azurestackhci/clusters` | [Schema or protocol](https://learn.microsoft.com/en-us/rest/api/stackhci/clusters/get?view=rest-stackhci-2024-04-01) |
| [`cluster_connectivity`](azure-local/python/get_cluster_connectivity.py) | `ARG: microsoft.azurestackhci/clusters` | [Schema or protocol](https://learn.microsoft.com/en-us/rest/api/stackhci/clusters/get?view=rest-stackhci-2024-04-01) |
| [`cluster_tags`](azure-local/python/get_cluster_tags.py) | `ARG: microsoft.azurestackhci/clusters` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/clusters) |
| [`cluster_nodes`](azure-local/python/get_cluster_nodes.py) | `ARG: microsoft.azurestackhci/clusters` | [Schema or protocol](https://learn.microsoft.com/en-us/rest/api/stackhci/clusters/get?view=rest-stackhci-2024-04-01) |
| [`arc_settings`](azure-local/python/get_arc_settings.py) | `ARG: microsoft.azurestackhci/clusters/arcsettings` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/clusters/arcsettings) |
| [`arc_extensions`](azure-local/python/get_arc_extensions.py) | `ARG: microsoft.azurestackhci/clusters/arcsettings/extensions` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/clusters/arcsettings/extensions) |
| [`deployment_settings`](azure-local/python/get_deployment_settings.py) | `ARG: microsoft.azurestackhci/clusters/deploymentsettings` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/clusters/deploymentsettings) |
| [`security_settings`](azure-local/python/get_security_settings.py) | `ARG: microsoft.azurestackhci/clusters/securitysettings` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/clusters/securitysettings) |
| [`update_summaries`](azure-local/python/get_update_summaries.py) | `ARG: microsoft.azurestackhci/clusters/updatesummaries` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/clusters/updatesummaries) |
| [`available_updates`](azure-local/python/get_available_updates.py) | `ARG: microsoft.azurestackhci/clusters/updates` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/clusters/updates) |
| [`update_runs`](azure-local/python/get_update_runs.py) | `ARG: microsoft.azurestackhci/clusters/updates/updateruns` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/clusters/updates/updateruns) |
| [`edge_devices`](azure-local/python/get_edge_devices.py) | `ARG: microsoft.azurestackhci/edgedevices` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/edgedevices) |
| [`gallery_images`](azure-local/python/get_gallery_images.py) | `ARG: microsoft.azurestackhci/galleryimages` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/galleryimages) |
| [`marketplace_images`](azure-local/python/get_marketplace_images.py) | `ARG: microsoft.azurestackhci/marketplacegalleryimages` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/marketplacegalleryimages) |
| [`logical_networks`](azure-local/python/get_logical_networks.py) | `ARG: microsoft.azurestackhci/logicalnetworks` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/logicalnetworks) |
| [`network_interfaces`](azure-local/python/get_network_interfaces.py) | `ARG: microsoft.azurestackhci/networkinterfaces` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networkinterfaces) |
| [`storage_containers`](azure-local/python/get_storage_containers.py) | `ARG: microsoft.azurestackhci/storagecontainers` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/storagecontainers) |
| [`virtual_hard_disks`](azure-local/python/get_virtual_hard_disks.py) | `ARG: microsoft.azurestackhci/virtualharddisks` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/virtualharddisks) |
| [`vm_instances`](azure-local/python/get_vm_instances.py) | `ARG: microsoft.azurestackhci/virtualmachineinstances` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/virtualmachineinstances) |
| [`vm_hardware`](azure-local/python/get_vm_hardware.py) | `ARG: microsoft.azurestackhci/virtualmachineinstances` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/virtualmachineinstances) |
| [`vm_disks`](azure-local/python/get_vm_disks.py) | `ARG: microsoft.azurestackhci/virtualmachineinstances` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/virtualmachineinstances) |
| [`vm_network_adapters`](azure-local/python/get_vm_network_adapters.py) | `ARG: microsoft.azurestackhci/virtualmachineinstances` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/virtualmachineinstances) |
| [`guest_agents`](azure-local/python/get_guest_agents.py) | `ARG: microsoft.azurestackhci/virtualmachineinstances/guestagents` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/virtualmachineinstances/guestagents) |
| [`hybrid_identity`](azure-local/python/get_hybrid_identity.py) | `ARG: microsoft.azurestackhci/virtualmachineinstances/hybrididentitymetadata` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/virtualmachineinstances/hybrididentitymetadata) |

## Azure Local SDN managed on premises

| Report | Source and API | Microsoft reference |
| --- | --- | --- |
| [`logical_networks`](azure-local-sdn-onprem/python/get_logical_networks.py) | `NC: /networking/v1/logicalNetworks` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`logical_subnets`](azure-local-sdn-onprem/python/get_logical_subnets.py) | `NC: /networking/v1/logicalNetworks/{id}/subnets` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`virtual_networks`](azure-local-sdn-onprem/python/get_virtual_networks.py) | `NC: /networking/v1/virtualNetworks` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`virtual_subnets`](azure-local-sdn-onprem/python/get_virtual_subnets.py) | `NC: /networking/v1/virtualNetworks/{id}/subnets` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`network_interfaces`](azure-local-sdn-onprem/python/get_network_interfaces.py) | `NC: /networking/v1/networkInterfaces` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`nic_ip_configurations`](azure-local-sdn-onprem/python/get_nic_ip_configurations.py) | `NC: /networking/v1/networkInterfaces/{id}/ipConfigurations` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`access_control_lists`](azure-local-sdn-onprem/python/get_access_control_lists.py) | `NC: /networking/v1/accessControlLists` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`acl_rules`](azure-local-sdn-onprem/python/get_acl_rules.py) | `NC: /networking/v1/accessControlLists/{id}/aclRules` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`acl_allow_rules`](azure-local-sdn-onprem/python/get_acl_allow_rules.py) | `NC: /networking/v1/accessControlLists/{id}/aclRules` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`acl_deny_rules`](azure-local-sdn-onprem/python/get_acl_deny_rules.py) | `NC: /networking/v1/accessControlLists/{id}/aclRules` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`route_tables`](azure-local-sdn-onprem/python/get_route_tables.py) | `NC: /networking/v1/routeTables` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`routes`](azure-local-sdn-onprem/python/get_routes.py) | `NC: /networking/v1/routeTables/{id}/routes` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`load_balancers`](azure-local-sdn-onprem/python/get_load_balancers.py) | `NC: /networking/v1/loadBalancers` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`lb_frontends`](azure-local-sdn-onprem/python/get_lb_frontends.py) | `NC: /networking/v1/loadBalancers/{id}/frontendIPConfigurations` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`lb_backends`](azure-local-sdn-onprem/python/get_lb_backends.py) | `NC: /networking/v1/loadBalancers/{id}/backendAddressPools` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`lb_probes`](azure-local-sdn-onprem/python/get_lb_probes.py) | `NC: /networking/v1/loadBalancers/{id}/probes` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`lb_rules`](azure-local-sdn-onprem/python/get_lb_rules.py) | `NC: /networking/v1/loadBalancers/{id}/loadBalancingRules` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`lb_inbound_nat`](azure-local-sdn-onprem/python/get_lb_inbound_nat.py) | `NC: /networking/v1/loadBalancers/{id}/inboundNatRules` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`lb_outbound_nat`](azure-local-sdn-onprem/python/get_lb_outbound_nat.py) | `NC: /networking/v1/loadBalancers/{id}/outboundNatRules` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`public_ips`](azure-local-sdn-onprem/python/get_public_ips.py) | `NC: /networking/v1/publicIPAddresses` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`gateways`](azure-local-sdn-onprem/python/get_gateways.py) | `NC: /networking/v1/gateways` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`gateway_pools`](azure-local-sdn-onprem/python/get_gateway_pools.py) | `NC: /networking/v1/GatewayPools` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`virtual_gateways`](azure-local-sdn-onprem/python/get_virtual_gateways.py) | `NC: /networking/v1/VirtualGateways` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`gateway_connections`](azure-local-sdn-onprem/python/get_gateway_connections.py) | `NC: /networking/v1/VirtualGateways/{id}/networkConnections` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |
| [`servers`](azure-local-sdn-onprem/python/get_servers.py) | `NC: /networking/v1/servers` | [Schema or protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ncnbi/6dbabf43-0fcd-439c-81e2-7eb794f7c140) |

## Azure Local SDN enabled by Azure Arc

| Report | Source and API | Microsoft reference |
| --- | --- | --- |
| [`logical_networks`](azure-local-sdn-arc-enabled/python/get_logical_networks.py) | `ARG: microsoft.azurestackhci/logicalnetworks` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/logicalnetworks) |
| [`logical_network_addressing`](azure-local-sdn-arc-enabled/python/get_logical_network_addressing.py) | `ARG: microsoft.azurestackhci/logicalnetworks` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/logicalnetworks) |
| [`logical_network_vlans`](azure-local-sdn-arc-enabled/python/get_logical_network_vlans.py) | `ARG: microsoft.azurestackhci/logicalnetworks` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/logicalnetworks) |
| [`logical_network_subnets`](azure-local-sdn-arc-enabled/python/get_logical_network_subnets.py) | `ARG: microsoft.azurestackhci/logicalnetworks` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/logicalnetworks) |
| [`logical_network_ip_pools`](azure-local-sdn-arc-enabled/python/get_logical_network_ip_pools.py) | `ARG: microsoft.azurestackhci/logicalnetworks` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/logicalnetworks) |
| [`logical_network_custom_locations`](azure-local-sdn-arc-enabled/python/get_logical_network_custom_locations.py) | `ARG: microsoft.azurestackhci/logicalnetworks` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/logicalnetworks) |
| [`logical_network_not_succeeded`](azure-local-sdn-arc-enabled/python/get_logical_network_not_succeeded.py) | `ARG: microsoft.azurestackhci/logicalnetworks` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/logicalnetworks) |
| [`network_interfaces`](azure-local-sdn-arc-enabled/python/get_network_interfaces.py) | `ARG: microsoft.azurestackhci/networkinterfaces` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networkinterfaces) |
| [`nic_ip_configurations`](azure-local-sdn-arc-enabled/python/get_nic_ip_configurations.py) | `ARG: microsoft.azurestackhci/networkinterfaces` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networkinterfaces) |
| [`nic_private_ips`](azure-local-sdn-arc-enabled/python/get_nic_private_ips.py) | `ARG: microsoft.azurestackhci/networkinterfaces` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networkinterfaces) |
| [`nic_security_groups`](azure-local-sdn-arc-enabled/python/get_nic_security_groups.py) | `ARG: microsoft.azurestackhci/networkinterfaces` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networkinterfaces) |
| [`nic_without_security_group`](azure-local-sdn-arc-enabled/python/get_nic_without_security_group.py) | `ARG: microsoft.azurestackhci/networkinterfaces` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networkinterfaces) |
| [`nic_not_succeeded`](azure-local-sdn-arc-enabled/python/get_nic_not_succeeded.py) | `ARG: microsoft.azurestackhci/networkinterfaces` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networkinterfaces) |
| [`security_groups`](azure-local-sdn-arc-enabled/python/get_security_groups.py) | `ARG: microsoft.azurestackhci/networksecuritygroups` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networksecuritygroups) |
| [`nsg_network_interfaces`](azure-local-sdn-arc-enabled/python/get_nsg_network_interfaces.py) | `ARG: microsoft.azurestackhci/networksecuritygroups` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networksecuritygroups) |
| [`nsg_subnets`](azure-local-sdn-arc-enabled/python/get_nsg_subnets.py) | `ARG: microsoft.azurestackhci/networksecuritygroups` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networksecuritygroups) |
| [`nsg_not_succeeded`](azure-local-sdn-arc-enabled/python/get_nsg_not_succeeded.py) | `ARG: microsoft.azurestackhci/networksecuritygroups` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networksecuritygroups) |
| [`security_rules`](azure-local-sdn-arc-enabled/python/get_security_rules.py) | `ARG: microsoft.azurestackhci/networksecuritygroups/securityrules` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networksecuritygroups/securityrules) |
| [`inbound_rules`](azure-local-sdn-arc-enabled/python/get_inbound_rules.py) | `ARG: microsoft.azurestackhci/networksecuritygroups/securityrules` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networksecuritygroups/securityrules) |
| [`outbound_rules`](azure-local-sdn-arc-enabled/python/get_outbound_rules.py) | `ARG: microsoft.azurestackhci/networksecuritygroups/securityrules` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networksecuritygroups/securityrules) |
| [`allow_rules`](azure-local-sdn-arc-enabled/python/get_allow_rules.py) | `ARG: microsoft.azurestackhci/networksecuritygroups/securityrules` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networksecuritygroups/securityrules) |
| [`deny_rules`](azure-local-sdn-arc-enabled/python/get_deny_rules.py) | `ARG: microsoft.azurestackhci/networksecuritygroups/securityrules` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networksecuritygroups/securityrules) |
| [`rule_sources`](azure-local-sdn-arc-enabled/python/get_rule_sources.py) | `ARG: microsoft.azurestackhci/networksecuritygroups/securityrules` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networksecuritygroups/securityrules) |
| [`rule_destinations`](azure-local-sdn-arc-enabled/python/get_rule_destinations.py) | `ARG: microsoft.azurestackhci/networksecuritygroups/securityrules` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networksecuritygroups/securityrules) |
| [`rule_protocols`](azure-local-sdn-arc-enabled/python/get_rule_protocols.py) | `ARG: microsoft.azurestackhci/networksecuritygroups/securityrules` | [Schema or protocol](https://learn.microsoft.com/en-us/azure/templates/microsoft.azurestackhci/networksecuritygroups/securityrules) |
