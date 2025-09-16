<#
.SYNOPSIS
    Installs Nutanix Guest Tools (NGT) on Windows Server 2025

.DESCRIPTION
    This script installs Nutanix Guest Tools (NGT) if the installer is present on the CD/DVD drive.
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

# Setup local file logging to C:\xoap-logs
try {
    $LogDir = 'C:\xoap-logs'
    if (-not (Test-Path $LogDir)) {
        New-Item -Path $LogDir -ItemType Directory -Force | Out-Null
    }
    $scriptName = [IO.Path]::GetFileNameWithoutExtension($PSCommandPath)
    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $LogFile = Join-Path $LogDir "$scriptName-$timestamp.log"
    Start-Transcript -Path $LogFile -Append | Out-Null
    Write-Host "Logging to: $LogFile"
} catch {
    Write-Warning "Failed to start transcript logging to C:\xoap-logs: $($_.Exception.Message)"
}

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Write-Host "[$timestamp] $Message"
}

trap {
    Write-Log "ERROR: $_"
    Write-Log "ERROR: $($_.ScriptStackTrace)"
    Write-Log "ERROR EXCEPTION: $($_.Exception.ToString())"
    try { Stop-Transcript | Out-Null } catch {}
    Exit 1
}

try {
    Write-Log 'Searching for Nutanix Guest Tools installer...'
    $cdDrives = Get-WmiObject Win32_CDROMDrive | Select-Object -ExpandProperty Drive
    $ngtInstaller = $null
    foreach ($drive in $cdDrives) {
        $installerPath = "$drive\Windows\NutanixGuestTools.msi"
        if (Test-Path $installerPath) {
            $ngtInstaller = $installerPath
            break
        }
    }

    if ($ngtInstaller) {
        Write-Log "Found NGT installer at $ngtInstaller. Installing..."
        Start-Process msiexec.exe -ArgumentList "/i `"$ngtInstaller`" /qn /norestart" -Wait
        Write-Log "Nutanix Guest Tools installation completed."
    } else {
        Write-Log "Nutanix Guest Tools installer not found on any CD/DVD drive."
    }
} finally {
    try { Stop-Transcript | Out-Null } catch {
        Write-Log "Failed to stop transcript logging: $($_.Exception.Message)"
    }
}
