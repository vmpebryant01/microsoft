# Report virtual network peering relationships.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'vnet_peerings' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
