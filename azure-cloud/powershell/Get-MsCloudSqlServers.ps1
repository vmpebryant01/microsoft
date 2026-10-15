# Inventory Azure SQL logical servers.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'sql_servers' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
