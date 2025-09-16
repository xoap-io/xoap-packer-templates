<#
.SYNOPSIS
    Enables Windows Remote Management on Windows builds.

.DESCRIPTION
    This script sets the network profile to Private, configures Windows Remote Management, and updates firewall rules.
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
    param([string]$Message)
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

# Set network connections profile to Private mode
Write-Log 'Setting the network connection profiles to Private...'
try {
    $connectionProfile = Get-NetConnectionProfile
    While ($connectionProfile.Name -eq 'Identifying...') {
        Start-Sleep -Seconds 10
        $connectionProfile = Get-NetConnectionProfile
    }
    Set-NetConnectionProfile -Name $connectionProfile.Name -NetworkCategory Private
    Write-Log "Network profile set to Private for: $($connectionProfile.Name)"
} catch {
    Write-Log "Warning: Could not set network profile to Private: $($_.Exception.Message)"
}

# Set the Windows Remote Management configuration
Write-Log 'Setting the Windows Remote Management configuration...'
try {
    winrm quickconfig -quiet
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'
    winrm set winrm/config/service/auth '@{Basic="true"}'
    Write-Log 'Windows Remote Management configuration completed.'
} catch {
    Write-Log "Warning: Could not configure Windows Remote Management: $($_.Exception.Message)"
}

# Allow Windows Remote Management in the Windows Firewall
Write-Log 'Allowing Windows Remote Management in the Windows Firewall...'
try {
    netsh advfirewall firewall set rule group="Windows Remote Administration" new enable=yes
    netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes action=allow
    Write-Log 'Windows Firewall rules configured for Remote Management.'
} catch {
    Write-Log "Warning: Could not configure Windows Firewall rules: $($_.Exception.Message)"
}

# Reset the autologon count
Write-Log 'Resetting autologon count...'
try {
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0
    Write-Log 'Autologon count reset to 0.'
} catch {
    Write-Log "Warning: Could not reset autologon count: $($_.Exception.Message)"
}

try { Stop-Transcript | Out-Null } catch {}
