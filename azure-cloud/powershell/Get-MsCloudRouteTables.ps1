# Inventory route tables and BGP propagation settings.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'route_tables' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
