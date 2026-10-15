# Report VM image references and operating system types.
# Author: Paul Bryant
param([string[]]$SubscriptionId, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-cloud' -ReportId 'vm_images' -SubscriptionId $SubscriptionId -OutputPath $OutputPath -Describe:$Describe
