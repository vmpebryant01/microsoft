# Inventory virtual machine scale sets and planned capacity.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'vm_scale_sets' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
