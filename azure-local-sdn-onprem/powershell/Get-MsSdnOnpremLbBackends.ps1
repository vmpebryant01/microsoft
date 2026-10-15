# Report load balancer backend address pools.
# Author: Paul Bryant
param([string]$ControllerUri, [string]$OutputPath, [switch]$Describe)
. (Join-Path $PSScriptRoot '..\..\_shared\ReportEngine.ps1')
Invoke-Report -Category 'azure-local-sdn-onprem' -ReportId 'lb_backends' -ControllerUri $ControllerUri -OutputPath $OutputPath -Describe:$Describe
