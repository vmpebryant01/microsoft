# Azure Local SDN enabled by Azure Arc

Author: Paul Bryant

Each report is available in PowerShell and Python. All reports read configuration only and export selected fields. Live behavior has not been validated.

These reports inspect Azure Local network resources used with the Arc-enabled SDN management model. Logical networks and interfaces can also exist without SDN enabled by Arc. The resource type alone does not establish the management model. Confirm SDN enablement on the target Azure Local instance before interpreting these reports as an Arc-enabled SDN inventory.

Provide `--custom-location` in Python or `-CustomLocation` in PowerShell with the full Azure custom location resource ID. Every Arc-enabled report requires it and includes only resources whose `extendedLocation.name` matches that ID. This limits the report to one location, but does not independently verify that SDN is enabled there.

| Report | PowerShell | Python |
| --- | --- | --- |
| Inventory Azure Local logical networks projected into Azure. | [PowerShell](powershell/Get-MsSdnArcLogicalNetworks.ps1) | [Python](python/get_logical_networks.py) |
| Report logical network subnets and DNS settings. | [PowerShell](powershell/Get-MsSdnArcLogicalNetworkAddressing.ps1) | [Python](python/get_logical_network_addressing.py) |
| Report VLAN identifiers on Azure Local logical network subnets. | [PowerShell](powershell/Get-MsSdnArcLogicalNetworkVlans.ps1) | [Python](python/get_logical_network_vlans.py) |
| Report subnet definitions within Azure Local logical networks. | [PowerShell](powershell/Get-MsSdnArcLogicalNetworkSubnets.ps1) | [Python](python/get_logical_network_subnets.py) |
| Report IP pools by Azure Local logical network subnet. | [PowerShell](powershell/Get-MsSdnArcLogicalNetworkIpPools.ps1) | [Python](python/get_logical_network_ip_pools.py) |
| Map Azure Local logical networks to custom locations. | [PowerShell](powershell/Get-MsSdnArcLogicalNetworkCustomLocations.ps1) | [Python](python/get_logical_network_custom_locations.py) |
| Find logical networks without a Succeeded provisioning state. | [PowerShell](powershell/Get-MsSdnArcLogicalNetworkNotSucceeded.ps1) | [Python](python/get_logical_network_not_succeeded.py) |
| Inventory Azure Local network interfaces projected into Azure. | [PowerShell](powershell/Get-MsSdnArcNetworkInterfaces.ps1) | [Python](python/get_network_interfaces.py) |
| Report Azure Local network interface IP configurations. | [PowerShell](powershell/Get-MsSdnArcNicIpConfigurations.ps1) | [Python](python/get_nic_ip_configurations.py) |
| Report private IP addresses assigned to Azure Local interfaces. | [PowerShell](powershell/Get-MsSdnArcNicPrivateIps.ps1) | [Python](python/get_nic_private_ips.py) |
| Report security group references on Azure Local interfaces. | [PowerShell](powershell/Get-MsSdnArcNicSecurityGroups.ps1) | [Python](python/get_nic_security_groups.py) |
| Find Azure Local interfaces without an NSG reference. | [PowerShell](powershell/Get-MsSdnArcNicWithoutSecurityGroup.ps1) | [Python](python/get_nic_without_security_group.py) |
| Find Azure Local interfaces without a Succeeded provisioning state. | [PowerShell](powershell/Get-MsSdnArcNicNotSucceeded.ps1) | [Python](python/get_nic_not_succeeded.py) |
| Inventory Azure Local network security groups. | [PowerShell](powershell/Get-MsSdnArcSecurityGroups.ps1) | [Python](python/get_security_groups.py) |
| Report interfaces associated with Azure Local NSGs. | [PowerShell](powershell/Get-MsSdnArcNsgNetworkInterfaces.ps1) | [Python](python/get_nsg_network_interfaces.py) |
| Report logical network subnets associated with NSGs. | [PowerShell](powershell/Get-MsSdnArcNsgSubnets.ps1) | [Python](python/get_nsg_subnets.py) |
| Find Azure Local NSGs without a Succeeded provisioning state. | [PowerShell](powershell/Get-MsSdnArcNsgNotSucceeded.ps1) | [Python](python/get_nsg_not_succeeded.py) |
| Inventory Azure Local SDN security rules. | [PowerShell](powershell/Get-MsSdnArcSecurityRules.ps1) | [Python](python/get_security_rules.py) |
| Report inbound Azure Local SDN security rules. | [PowerShell](powershell/Get-MsSdnArcInboundRules.ps1) | [Python](python/get_inbound_rules.py) |
| Report outbound Azure Local SDN security rules. | [PowerShell](powershell/Get-MsSdnArcOutboundRules.ps1) | [Python](python/get_outbound_rules.py) |
| Report Azure Local SDN rules that allow traffic. | [PowerShell](powershell/Get-MsSdnArcAllowRules.ps1) | [Python](python/get_allow_rules.py) |
| Report Azure Local SDN rules that deny traffic. | [PowerShell](powershell/Get-MsSdnArcDenyRules.ps1) | [Python](python/get_deny_rules.py) |
| Report source prefixes and ports for Azure Local rules. | [PowerShell](powershell/Get-MsSdnArcRuleSources.ps1) | [Python](python/get_rule_sources.py) |
| Report destination prefixes and ports for Azure Local rules. | [PowerShell](powershell/Get-MsSdnArcRuleDestinations.ps1) | [Python](python/get_rule_destinations.py) |
| Report protocol, priority and access for Azure Local rules. | [PowerShell](powershell/Get-MsSdnArcRuleProtocols.ps1) | [Python](python/get_rule_protocols.py) |

See the [repository guide](../README.md) for setup, credentials, scope and known limits.
