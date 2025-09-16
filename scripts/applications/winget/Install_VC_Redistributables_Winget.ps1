<#
.SYNOPSIS
    Installs Microsoft Visual C++ Redistributables using winget on Windows Server 2025

.DESCRIPTION
    This script installs the latest Microsoft Visual C++ Redistributables using winget.
    Developed and optimized for use with the XOAP Image Management module, but can be used independently.
    No liability is assumed for the function, use, or consequences of this freely available script.
    PowerShell is a product of Microsoft Corporation. XOAP is a product of RIS AG. © RIS AG

.COMPONENT
    PowerShell

.LINK
    https://github.com/xoap-io/xoap-packer-templates

#>
Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

try {
    $LogDir = 'C:\xoap-logs'
    if (-not (Test-Path $LogDir)) { New-Item -Path $LogDir -ItemType Directory -Force | Out-Null }
    $scriptName = [IO.Path]::GetFileNameWithoutExtension($PSCommandPath)
    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $LogFile = Join-Path $LogDir "$scriptName-$timestamp.log"
    Start-Transcript -Path $LogFile -Append | Out-Null
    Write-Host "Logging to: $LogFile"
} catch { Write-Warning "Failed to start transcript logging to C:\xoap-logs: $($_.Exception.Message)" }

function Write-Log { param($Message); $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'; Write-Host "[$timestamp] $Message" }

trap {
    Write-Log "ERROR: $_"
    Write-Log "ERROR: $($_.ScriptStackTrace)"
    Write-Log "ERROR EXCEPTION: $($_.Exception.ToString())"
    try { Stop-Transcript | Out-Null } catch {}
    Exit 1
}

$vcPackages = @(
    "Microsoft.VCRedist.2015+.x64",
    "Microsoft.VCRedist.2015+.x86",
    "Microsoft.VCRedist.2013.x64",
    "Microsoft.VCRedist.2013.x86",
    "Microsoft.VCRedist.2012.x64",
    "Microsoft.VCRedist.2012.x86",
    "Microsoft.VCRedist.2010.x64",
    "Microsoft.VCRedist.2010.x86"
)

try {
    foreach ($pkg in $vcPackages) {
        Write-Log "Installing $pkg via winget..."
        winget install --id $pkg --silent --accept-package-agreements --accept-source-agreements -e
        Write-Log "$pkg installed successfully."
    }
    Write-Log "All Visual C++ Redistributables installed."
} finally {
    try { Stop-Transcript | Out-Null } catch {}
}
