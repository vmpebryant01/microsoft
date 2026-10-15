# Inventory Azure Local logical networks projected into Azure.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'logical_networks' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
