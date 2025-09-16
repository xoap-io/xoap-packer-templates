<#
.SYNOPSIS
    Installs the XPS Viewer feature on Windows Server

.DESCRIPTION
    This script checks for and installs the XPS Viewer feature, with optimized logging and error handling.
    Developed for use with XOAP Image Management, but can be used independently.
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
$WindowsFeature = "XPS-Viewer"

# Setup local file logging to C:\xoap-logs
try {
    $LogDir = 'C:\xoap-logs'
    if (-not (Test-Path $LogDir)) {
        New-Item -Path $LogDir -ItemType Directory -Force | Out-Null
    }
    $scriptName = [IO.Path]::GetFileNameWithoutExtension($PSCommandPath)
    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $LogFile = Join-Path $LogDir "$scriptName-$timestamp.log"
    Write-Host "Logging to: $LogFile"
} catch {
    Write-Warning "Failed to set up logging to C:\xoap-logs: $($_.Exception.Message)"
    $LogFile = $null
}

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logEntry = "[$timestamp] $Message"
    Write-Host $logEntry
    if ($LogFile) {
        Add-Content -Path $LogFile -Value $logEntry
    }
}

try {
    if (-not (Get-Module -ListAvailable -Name ServerManager)) {
        Write-Log "ServerManager module not available. Cannot proceed."
        exit 1
    }
    Import-Module ServerManager
    $feature = Get-WindowsFeature -Name $WindowsFeature
    if ($feature) {
        switch ($feature.InstallState) {
            'Available' {
                Write-Log "Installing $WindowsFeature..."
                Add-WindowsFeature -Name $WindowsFeature -IncludeAllSubFeature | Out-Null
                Write-Log "$WindowsFeature installed successfully."
            }
            'Installed' {
                Write-Log "$WindowsFeature is already installed."
            }
            default {
                Write-Log "$WindowsFeature is in state: $($feature.InstallState)"
            }
        }
    } else {
        Write-Log "$WindowsFeature feature not found on this system."
    }
} catch {
    Write-Log "Error: $($_.Exception.Message)"
    exit 1
}
