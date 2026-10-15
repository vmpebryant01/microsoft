# Inventory Azure Local VM guest agent resources.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'guest_agents' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
