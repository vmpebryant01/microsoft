# Report Azure Local SDN rules that allow traffic.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'allow_rules' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
