<#
.SYNOPSIS
  Fixes network connections for WinRM on Windows Server

.DESCRIPTION
  This script sets network connections to Private if they are Public, enabling PowerShell Remoting. Developed for XOAP Image Management, but can be used independently. No liability is assumed for the function, use, or consequences of this freely available script. PowerShell is a product of Microsoft Corporation. XOAP is a product of RIS AG. © RIS AG

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

function Set-NetworkTypeToPrivate {
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPositionalParameters', '')]
  param()
  try {
    Write-Log 'Checking OS version...'
    if ([environment]::OSVersion.version.Major -lt 6) {
      Write-Log 'OS version is older than Vista. Skipping network location change.'
      return
    }

    Write-Log 'Checking domain role...'
    if (1, 3, 4, 5 -contains (Get-CimInstance win32_computersystem).DomainRole) {
      Write-Log 'Domain joined. Skipping network location change.'
      return
    }

    Write-Log 'Getting network connections...'
    $networkListManager = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))
    $connections = $networkListManager.GetNetworkConnections()

    $connections | ForEach-Object {
      $name = $_.GetNetwork().GetName()
      $category = $_.GetNetwork().GetCategory()
      Write-Log "$name category was previously set to $category"
      # Uncomment the next line to actually set the category to Private (1)
      # $_.GetNetwork().SetCategory(1)
      $newCategory = $_.GetNetwork().GetCategory()
      Write-Log "$name changed to category $newCategory"
    }
  } catch {
    Write-Log "Error: $($_.Exception.Message)"
  }
}

Set-NetworkTypeToPrivate
