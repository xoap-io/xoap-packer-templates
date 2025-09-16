<#
.SYNOPSIS
    Disables screensaver and display timeout settings on Windows Server

.DESCRIPTION
    This script disables the screensaver and configures power settings to prevent display and standby timeouts. Developed for XOAP Image Management, but can be used independently. No liability is assumed for the function, use, or consequences of this freely available script. PowerShell is a product of Microsoft Corporation. XOAP is a product of RIS AG. © RIS AG

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

trap {
    Write-Log "ERROR: $_"
    Write-Log "ERROR: $($_.ScriptStackTrace)"
    Write-Log "ERROR EXCEPTION: $($_.Exception.ToString())"
    Exit 1
}

# Import common utilities if available
$commonPath = "$PSScriptRoot/packer_windows_server_2025_scripts/common/BuildUtils.psm1"
if (Test-Path $commonPath) {
    . $commonPath
    Start-LogScope -Name 'disable-screensaver'
}

try {
    Write-Log 'Disabling screensaver and display timeout settings...'

    # Disable screensaver for current user
    try {
        $regPath = "HKCU:\Control Panel\Desktop"
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        Set-ItemProperty -Path $regPath -Name "ScreenSaveActive" -Value 0 -Type DWord -Force
        Write-Log 'Disabled screensaver for current user.'
    } catch {
        Write-Log "Warning: Could not disable screensaver: $($_.Exception.Message)"
    }

    # Configure power settings to prevent display timeout
    try {
        & powercfg -x -monitor-timeout-ac 0
        Write-Log 'Disabled AC monitor timeout.'
    } catch {
        Write-Log "Warning: Could not disable AC monitor timeout: $($_.Exception.Message)"
    }

    try {
        & powercfg -x -monitor-timeout-dc 0
        Write-Log 'Disabled DC monitor timeout.'
    } catch {
        Write-Log "Warning: Could not disable DC monitor timeout: $($_.Exception.Message)"
    }

    # Also disable system standby/sleep
    try {
        & powercfg -x -standby-timeout-ac 0
        Write-Log 'Disabled AC standby timeout.'
    } catch {
        Write-Log "Warning: Could not disable AC standby timeout: $($_.Exception.Message)"
    }

    try {
        & powercfg -x -standby-timeout-dc 0
        Write-Log 'Disabled DC standby timeout.'
    } catch {
        Write-Log "Warning: Could not disable DC standby timeout: $($_.Exception.Message)"
    }

    Write-Log 'Successfully configured screensaver and power settings.'

} finally {
    if (Get-Command Stop-LogScope -ErrorAction SilentlyContinue) {
        Stop-LogScope
    }
}
