# Azure Local SDN managed on premises

Author: Paul Bryant

Each report is available in PowerShell and Python. All reports read configuration only and export selected fields. Live behavior has not been validated.

| Report | PowerShell | Python |
| --- | --- | --- |
| Inventory Network Controller logical networks. | [PowerShell](powershell/Get-MsSdnOnpremLogicalNetworks.ps1) | [Python](python/get_logical_networks.py) |
| Report logical subnets and VLANs. | [PowerShell](powershell/Get-MsSdnOnpremLogicalSubnets.ps1) | [Python](python/get_logical_subnets.py) |
| Inventory tenant virtual networks. | [PowerShell](powershell/Get-MsSdnOnpremVirtualNetworks.ps1) | [Python](python/get_virtual_networks.py) |
| Report tenant virtual network subnets. | [PowerShell](powershell/Get-MsSdnOnpremVirtualSubnets.ps1) | [Python](python/get_virtual_subnets.py) |
| Inventory Network Controller network interfaces. | [PowerShell](powershell/Get-MsSdnOnpremNetworkInterfaces.ps1) | [Python](python/get_network_interfaces.py) |
| Report Network Controller NIC IP configurations. | [PowerShell](powershell/Get-MsSdnOnpremNicIpConfigurations.ps1) | [Python](python/get_nic_ip_configurations.py) |
| Inventory SDN access control lists. | [PowerShell](powershell/Get-MsSdnOnpremAccessControlLists.ps1) | [Python](python/get_access_control_lists.py) |
| Report SDN ACL rules. | [PowerShell](powershell/Get-MsSdnOnpremAclRules.ps1) | [Python](python/get_acl_rules.py) |
| Report SDN ACL rules that allow traffic. | [PowerShell](powershell/Get-MsSdnOnpremAclAllowRules.ps1) | [Python](python/get_acl_allow_rules.py) |
| Report SDN ACL rules that deny traffic. | [PowerShell](powershell/Get-MsSdnOnpremAclDenyRules.ps1) | [Python](python/get_acl_deny_rules.py) |
| Inventory tenant route tables. | [PowerShell](powershell/Get-MsSdnOnpremRouteTables.ps1) | [Python](python/get_route_tables.py) |
| Report tenant route prefixes and next hops. | [PowerShell](powershell/Get-MsSdnOnpremRoutes.ps1) | [Python](python/get_routes.py) |
| Inventory SDN load balancers. | [PowerShell](powershell/Get-MsSdnOnpremLoadBalancers.ps1) | [Python](python/get_load_balancers.py) |
| Report load balancer frontend IP configurations. | [PowerShell](powershell/Get-MsSdnOnpremLbFrontends.ps1) | [Python](python/get_lb_frontends.py) |
| Report load balancer backend address pools. | [PowerShell](powershell/Get-MsSdnOnpremLbBackends.ps1) | [Python](python/get_lb_backends.py) |
| Report load balancer health probe settings. | [PowerShell](powershell/Get-MsSdnOnpremLbProbes.ps1) | [Python](python/get_lb_probes.py) |
| Report load balancing rules and port mappings. | [PowerShell](powershell/Get-MsSdnOnpremLbRules.ps1) | [Python](python/get_lb_rules.py) |
| Report load balancer inbound NAT rules. | [PowerShell](powershell/Get-MsSdnOnpremLbInboundNat.ps1) | [Python](python/get_lb_inbound_nat.py) |
| Report load balancer outbound NAT rules. | [PowerShell](powershell/Get-MsSdnOnpremLbOutboundNat.ps1) | [Python](python/get_lb_outbound_nat.py) |
| Inventory Network Controller public IP resources. | [PowerShell](powershell/Get-MsSdnOnpremPublicIps.ps1) | [Python](python/get_public_ips.py) |
| Inventory SDN gateway virtual machines. | [PowerShell](powershell/Get-MsSdnOnpremGateways.ps1) | [Python](python/get_gateways.py) |
| Inventory gateway pools and capacity. | [PowerShell](powershell/Get-MsSdnOnpremGatewayPools.ps1) | [Python](python/get_gateway_pools.py) |
| Inventory tenant virtual gateways. | [PowerShell](powershell/Get-MsSdnOnpremVirtualGateways.ps1) | [Python](python/get_virtual_gateways.py) |
| Report tenant virtual gateway network connections. | [PowerShell](powershell/Get-MsSdnOnpremGatewayConnections.ps1) | [Python](python/get_gateway_connections.py) |
| Inventory Network Controller managed servers. | [PowerShell](powershell/Get-MsSdnOnpremServers.ps1) | [Python](python/get_servers.py) |

See the [repository guide](../README.md) for setup, credentials, scope and known limits.
