# Inventory tenant route tables.
# Author: Paul Bryant
param([string]$ControllerUri, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-onprem' -ReportId 'route_tables' -ControllerUri $ControllerUri -OutputPath $OutputPath -Describe:$Describe
