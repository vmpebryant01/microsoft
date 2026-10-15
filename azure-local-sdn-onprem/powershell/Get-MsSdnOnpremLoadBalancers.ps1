# Inventory SDN load balancers.
# Author: Paul Bryant
param([string]$ControllerUri, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-onprem' -ReportId 'load_balancers' -ControllerUri $ControllerUri -OutputPath $OutputPath -Describe:$Describe
