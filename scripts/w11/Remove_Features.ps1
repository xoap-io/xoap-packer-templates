<#
.SYNOPSIS
    Removes unwanted Windows optional features from Windows Server 2025.

.DESCRIPTION
    This script disables and removes selected Windows optional features if installed.
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
    $LogFile = $null
}

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logEntry = "[$timestamp] $Message"
    Write-Host $logEntry
}

trap {
    Write-Log "ERROR: $_"
    Write-Log "ERROR: $($_.ScriptStackTrace)"
    Write-Log "ERROR EXCEPTION: $($_.Exception.ToString())"
    try { Stop-Transcript | Out-Null } catch {}
    Exit 1
}

$selectors = @(
    'MediaPlayback',
    'MicrosoftWindowsPowerShellV2Root',
    'Recall',
    'Microsoft-SnippingTool',
    'Internet-Explorer-Optional-amd64',
    'XPS-Viewer',
    'Printing-PrintToPDFServices-Features',
    'WorkFolders-Client',
    'WindowsMediaPlayer',
    'Windows-Defender-Features',
    'FaxServicesClientPackage',
    'WAS-ProcessModel',
    'IIS-WebServerRole',
    'IIS-WebServer',
    'IIS-FTPServer',
    'IIS-WebDAV',
    'IIS-ManagementConsole'
)

try {
    $installedFeatures = Get-WindowsOptionalFeature -Online | Where-Object { $_.State -notin @('Disabled','DisabledWithPayloadRemoved') }

    foreach ($selector in $selectors) {
        $feature = $installedFeatures | Where-Object { $_.FeatureName -eq $selector }
        if ($feature) {
            Write-Log "Removing feature: $selector"
            try {
                $feature | Disable-WindowsOptionalFeature -Online -Remove -NoRestart -ErrorAction Stop
                Write-Log "Feature removed: $selector"
            } catch {
                Write-Log "Failed to remove feature: $selector - $($_.Exception.Message)"
            }
        } else {
            Write-Log "Feature not installed: $selector"
        }
    }
    Write-Log "Feature removal script completed."
} finally {
    try { Stop-Transcript | Out-Null } catch {
        Write-Log "Failed to stop transcript logging: $($_.Exception.Message)"
    }
}
