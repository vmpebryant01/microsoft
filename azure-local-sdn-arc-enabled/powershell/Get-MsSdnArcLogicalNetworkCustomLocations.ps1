# Map Azure Local logical networks to custom locations.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'logical_network_custom_locations' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
