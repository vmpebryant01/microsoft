# Inventory Azure network security groups.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'network_security_groups' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
