# Report inbound Azure Local SDN security rules.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'inbound_rules' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
