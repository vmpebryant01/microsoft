# Inventory managed disks and their sizes.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'managed_disks' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
