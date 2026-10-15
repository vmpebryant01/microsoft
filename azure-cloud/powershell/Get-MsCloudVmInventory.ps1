# Inventory virtual machines and their hardware size.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'vm_inventory' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
