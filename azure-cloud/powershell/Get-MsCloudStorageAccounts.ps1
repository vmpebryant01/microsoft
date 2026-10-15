# Inventory Azure storage accounts and network defaults.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'storage_accounts' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
