# Inventory managed disk snapshots.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'snapshots' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
