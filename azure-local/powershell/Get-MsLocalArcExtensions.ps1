# Inventory Azure Local Arc extensions.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'arc_extensions' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
