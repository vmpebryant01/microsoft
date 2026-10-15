# Report VLAN identifiers on Azure Local logical network subnets.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$CustomLocation, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'logical_network_vlans' -SubscriptionId $SubscriptionId -CustomLocation $CustomLocation -OutputPath $OutputPath -Describe:$Describe
