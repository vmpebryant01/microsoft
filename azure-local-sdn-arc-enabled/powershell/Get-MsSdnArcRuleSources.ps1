# Report source prefixes and ports for Azure Local rules.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'rule_sources' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
