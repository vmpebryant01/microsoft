# Azure Cloud

Author: Paul Bryant

Each report is available in PowerShell and Python. All reports read configuration only and export selected fields. Live behavior has not been validated.

| Report | PowerShell | Python |
| --- | --- | --- |
| Inventory virtual machines and their hardware size. | [PowerShell](powershell/Get-MsCloudVmInventory.ps1) | [Python](python/get_vm_inventory.py) |
| Report VM image references and operating system types. | [PowerShell](powershell/Get-MsCloudVmImages.ps1) | [Python](python/get_vm_images.py) |
| Report operating system disks attached to VMs. | [PowerShell](powershell/Get-MsCloudVmOsDisks.ps1) | [Python](python/get_vm_os_disks.py) |
| Report every VM data disk reference. | [PowerShell](powershell/Get-MsCloudVmDataDisks.ps1) | [Python](python/get_vm_data_disks.py) |
| Report VM network interface references. | [PowerShell](powershell/Get-MsCloudVmNetworkInterfaces.ps1) | [Python](python/get_vm_network_interfaces.py) |
| Inventory managed disks and their sizes. | [PowerShell](powershell/Get-MsCloudManagedDisks.ps1) | [Python](python/get_managed_disks.py) |
| Find managed disks reported as unattached. | [PowerShell](powershell/Get-MsCloudUnattachedDisks.ps1) | [Python](python/get_unattached_disks.py) |
| Report managed disk encryption settings. | [PowerShell](powershell/Get-MsCloudDiskEncryption.ps1) | [Python](python/get_disk_encryption.py) |
| Inventory managed disk snapshots. | [PowerShell](powershell/Get-MsCloudSnapshots.ps1) | [Python](python/get_snapshots.py) |
| Inventory virtual machine scale sets and planned capacity. | [PowerShell](powershell/Get-MsCloudVmScaleSets.ps1) | [Python](python/get_vm_scale_sets.py) |
| Inventory availability sets and fault domain settings. | [PowerShell](powershell/Get-MsCloudAvailabilitySets.ps1) | [Python](python/get_availability_sets.py) |
| Inventory Azure virtual networks and address spaces. | [PowerShell](powershell/Get-MsCloudVirtualNetworks.ps1) | [Python](python/get_virtual_networks.py) |
| Report embedded subnet definitions in virtual networks. | [PowerShell](powershell/Get-MsCloudSubnets.ps1) | [Python](python/get_subnets.py) |
| Report virtual network peering relationships. | [PowerShell](powershell/Get-MsCloudVnetPeerings.ps1) | [Python](python/get_vnet_peerings.py) |
| Inventory Azure network security groups. | [PowerShell](powershell/Get-MsCloudNetworkSecurityGroups.ps1) | [Python](python/get_network_security_groups.py) |
| Report custom Azure network security rules. | [PowerShell](powershell/Get-MsCloudNsgRules.ps1) | [Python](python/get_nsg_rules.py) |
| Inventory route tables and BGP propagation settings. | [PowerShell](powershell/Get-MsCloudRouteTables.ps1) | [Python](python/get_route_tables.py) |
| Report routes embedded in Azure route tables. | [PowerShell](powershell/Get-MsCloudRoutes.ps1) | [Python](python/get_routes.py) |
| Inventory Azure public IP addresses. | [PowerShell](powershell/Get-MsCloudPublicIps.ps1) | [Python](python/get_public_ips.py) |
| Inventory Azure load balancers and SKU. | [PowerShell](powershell/Get-MsCloudLoadBalancers.ps1) | [Python](python/get_load_balancers.py) |
| Inventory Azure storage accounts and network defaults. | [PowerShell](powershell/Get-MsCloudStorageAccounts.ps1) | [Python](python/get_storage_accounts.py) |
| Inventory Key Vault resources and access model. | [PowerShell](powershell/Get-MsCloudKeyVaults.ps1) | [Python](python/get_key_vaults.py) |
| Inventory Azure SQL logical servers. | [PowerShell](powershell/Get-MsCloudSqlServers.ps1) | [Python](python/get_sql_servers.py) |
| Inventory Azure SQL databases and service tiers. | [PowerShell](powershell/Get-MsCloudSqlDatabases.ps1) | [Python](python/get_sql_databases.py) |
| Inventory App Service applications and runtime state. | [PowerShell](powershell/Get-MsCloudAppServices.ps1) | [Python](python/get_app_services.py) |

See the [repository guide](../README.md) for setup, credentials, scope and known limits.
