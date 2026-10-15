# Report operating system disks attached to VMs.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'vm_os_disks' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
