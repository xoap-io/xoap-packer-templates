<#
.SYNOPSIS
    Installs Git using winget on Windows Server 2025

.DESCRIPTION
    This script installs Git using winget.
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

try {
    Write-Log "Installing Git via winget..."
    winget install --id Git.Git --silent --accept-package-agreements --accept-source-agreements -e
    Write-Log "Git installed successfully."
} finally {
    try { Stop-Transcript | Out-Null } catch {}
}
