# Report every VM data disk reference.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'vm_data_disks' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
