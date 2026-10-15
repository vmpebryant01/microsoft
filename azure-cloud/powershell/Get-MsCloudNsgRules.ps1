# Report custom Azure network security rules.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'nsg_rules' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
