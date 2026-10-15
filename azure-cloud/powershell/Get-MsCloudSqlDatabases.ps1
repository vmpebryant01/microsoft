# Inventory Azure SQL databases and service tiers.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'sql_databases' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
