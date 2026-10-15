# Report VM network interface references.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'vm_network_interfaces' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
