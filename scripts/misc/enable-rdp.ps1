<#
.SYNOPSIS
  Enables Remote Desktop Protocol (RDP) on Windows Server

.DESCRIPTION
  This script enables RDP and configures firewall rules for remote access. Developed for XOAP Image Management, but can be used independently. No liability is assumed for the function, use, or consequences of this freely available script. PowerShell is a product of Microsoft Corporation. XOAP is a product of RIS AG. © RIS AG

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

Start-Transcript -Append $LogFile

try {
  Write-Log "Enabling RDP firewall rule for port 3389..."
  netsh advfirewall firewall add rule name="Open Port 3389" dir=in action=allow protocol=TCP localport=3389
  Write-Log "RDP firewall rule added."

  Write-Log "Enabling RDP in registry..."
  reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
  Write-Log "RDP enabled in registry."
} catch {
  Write-Log "Error: $($_.Exception.Message)"
  exit 1
}
