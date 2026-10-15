# Offline checks for the PowerShell report entry points.
# Author: Paul Bryant

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
. (Join-Path $root '_shared/ReportEngine.ps1')

$scripts = @(Get-ChildItem -LiteralPath $root -Recurse -Filter '*.ps1' | Where-Object { $_.DirectoryName -match '[\\/](powershell)$' })
if ($scripts.Count -ne 100) { throw "Expected 100 PowerShell reports, found $($scripts.Count)" }
foreach ($script in $scripts) {
    $tokens = $null
    $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($script.FullName, [ref]$tokens, [ref]$errors) | Out-Null
    if ($errors.Count) { throw "PowerShell parse error in $($script.FullName): $($errors[0])" }
}

$sample = Join-Path $root 'azure-cloud/powershell/Get-MsCloudVmInventory.ps1'
$description = & $sample -Describe
if ($description.id -ne 'vm_inventory') { throw 'PowerShell report description failed' }

$report = @{
    expand = 'properties.securityRules'
    filter = @{ path = 'item.properties.access'; op = 'eq'; value = 'Deny' }
    fields = @(@('nsg', 'name'), @('rule', 'item.name'))
}
$resources = @(@{ name = 'nsg-one'; properties = @{ securityRules = @(
    @{ name = 'allow'; properties = @{ access = 'Allow' } },
    @{ name = 'deny'; properties = @{ access = 'Deny' } }
) } })
$rows = @(ConvertTo-ReportRows $resources $report)
if ($rows.Count -ne 1 -or $rows[0].rule -ne 'deny') { throw 'PowerShell report projection failed' }

$emptyNetworkController = ConvertTo-NcItems (ConvertTo-HashPayload @())
if (@($emptyNetworkController).Count -ne 0) { throw 'Empty Network Controller response failed' }
$emptyRows = ConvertTo-ReportRows @() $report
if (@($emptyRows).Count -ne 0) { throw 'Empty report projection failed' }
if ((ConvertTo-SafeCsvValue (-1)) -ne '-1') { throw 'Negative number CSV conversion failed' }

function Search-AzGraph {
    param($Query, $Subscription, $First, $ErrorAction)
    return [pscustomobject]@{ Data = @(); SkipToken = $null; ResultTruncated = $false }
}
$emptyAzure = Get-ArgResources 'microsoft.compute/virtualmachines' @('test-subscription')
if (@($emptyAzure).Count -ne 0) { throw 'Empty Azure Resource Graph response failed' }

Write-Output 'PowerShell report checks passed.'
