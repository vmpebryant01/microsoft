# Inventory Key Vault resources and access model.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'key_vaults' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
