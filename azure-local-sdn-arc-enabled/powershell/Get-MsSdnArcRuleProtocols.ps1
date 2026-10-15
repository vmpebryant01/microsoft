# Report protocol, priority and access for Azure Local rules.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'rule_protocols' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
