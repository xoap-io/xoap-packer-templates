
<#
.SYNOPSIS
    Regenerates the .NET native image cache on Windows Server

.DESCRIPTION
    This script updates and executes queued items for the .NET native image cache using ngen.exe. Developed for XOAP Image Management, but can be used independently. No liability is assumed for the function, use, or consequences of this freely available script. PowerShell is a product of Microsoft Corporation. XOAP is a product of RIS AG. © RIS AG

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

try {
    if ([Environment]::Is64BitOperatingSystem) {
        Write-Log "Updating and executing queued items for 64-bit .NET Framework..."
        Invoke-Expression "$env:windir\microsoft.net\framework\v4.0.30319\ngen.exe update /force /queue"
        Invoke-Expression "$env:windir\microsoft.net\framework64\v4.0.30319\ngen.exe update /force /queue"
        Invoke-Expression "$env:windir\microsoft.net\framework\v4.0.30319\ngen.exe executequeueditems"
        Invoke-Expression "$env:windir\microsoft.net\framework64\v4.0.30319\ngen.exe executequeueditems"
    } else {
        Write-Log "Updating and executing queued items for 32-bit .NET Framework..."
        Invoke-Expression "$env:windir\microsoft.net\framework\v4.0.30319\ngen.exe update /force /queue"
        Invoke-Expression "$env:windir\microsoft.net\framework\v4.0.30319\ngen.exe executequeueditems"
    }
    Write-Log ".NET native image cache regeneration complete."
} catch {
    Write-Log "Error: $($_.Exception.Message)"
    exit 1
}
