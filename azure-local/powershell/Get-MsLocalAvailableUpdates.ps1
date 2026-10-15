# Inventory available cluster updates.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'available_updates' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
