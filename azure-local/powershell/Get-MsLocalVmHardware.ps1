# Report Azure Local VM hardware profiles.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'vm_hardware' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
