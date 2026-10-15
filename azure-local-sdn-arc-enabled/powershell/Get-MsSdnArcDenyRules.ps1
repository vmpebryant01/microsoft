# Report Azure Local SDN rules that deny traffic.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$CustomLocation, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-arc-enabled' -ReportId 'deny_rules' -SubscriptionId $SubscriptionId -CustomLocation $CustomLocation -OutputPath $OutputPath -Describe:$Describe
