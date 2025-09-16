<#
.SYNOPSIS
    Removes unwanted Windows capabilities from Windows 11.

.DESCRIPTION
    This script removes selected Windows capabilities if installed.
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
    'Print.Fax.Scan',
    'Language.Handwriting',
    'Browser.InternetExplorer',
    'MathRecognizer',
    'OneCoreUAP.OneSync',
    'Microsoft.Windows.MSPaint',
    'App.Support.QuickAssist',
    'Microsoft.Windows.SnippingTool',
    'Language.Speech',
    'Language.TextToSpeech',
    'App.StepsRecorder',
    'Hello.Face.18967',
    'Hello.Face.Migration.18967',
    'Hello.Face.20134',
    'Media.WindowsMediaPlayer',
    'Microsoft.Windows.Notepad',
    'Microsoft.Windows.PowerShell.ISE',
    'Microsoft.Windows.XPSViewer'
)

try {
    $installedCaps = Get-WindowsCapability -Online | Where-Object { $_.State -notin @('NotPresent','Removed') }

    foreach ($selector in $selectors) {
        $found = $installedCaps | Where-Object { ($_.Name -split '~')[0] -eq $selector }
        if ($found) {
            foreach ($cap in $found) {
                Write-Log "Removing capability: $($cap.Name)"
                try {
                    $cap | Remove-WindowsCapability -Online -ErrorAction Stop
                    Write-Log "Capability removed: $($cap.Name)"
                } catch {
                    Write-Log "Failed to remove capability: $($cap.Name) - $($_.Exception.Message)"
                }
            }
        } else {
            Write-Log "Capability not installed: $selector"
        }
    }
    Write-Log "Capability removal script completed."
} finally {
    try { Stop-Transcript | Out-Null } catch {
        Write-Log "Failed to stop transcript logging: $($_.Exception.Message)"
    }
}
