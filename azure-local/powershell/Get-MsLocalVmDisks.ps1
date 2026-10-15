# Report data disk references on Azure Local VMs.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local' -ReportId 'vm_disks' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
