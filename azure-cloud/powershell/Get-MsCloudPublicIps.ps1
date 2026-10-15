# Inventory Azure public IP addresses.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'public_ips' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
