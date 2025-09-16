<#
.SYNOPSIS
    Applies UI tweaks for Windows Server 2025.

.DESCRIPTION
    This script sets registry values to optimize UI experience and performance.
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
    Write-Log 'Sleeping for 60m to give you time to look around the virtual machine before self-destruction...'
    Start-Sleep -Seconds (60*60)
    Exit 1
}

$uiTweaks = @(
    @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'; Name='HideFileExt'; Type='DWORD'; Value=0; Desc='Show file extensions'},
    @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'; Name='Hidden'; Type='DWORD'; Value=1; Desc='Show hidden files'},
    @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'; Name='LaunchTo'; Type='DWORD'; Value=1; Desc='Launch explorer to This PC'},
    @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'; Name='FullPathAddress'; Type='DWORD'; Value=1; Desc='Show full path in address bar'},
    @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'; Name='EnableBalloonTips'; Type='DWORD'; Value=0; Desc='Disable notification popups'},
    @{Path='HKCU:\Software\Microsoft\Windows\Windows Error Reporting'; Name='DontShowUI'; Type='DWORD'; Value=0; Desc='Disable error reporting popups'},
    @{Path='HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability'; Name='ShutdownReasonOn'; Type='DWORD'; Value=0; Desc='Disable shutdown reason prompt'},
    @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects'; Name='VisualFXSetting'; Type='DWORD'; Value=2; Desc='Set visual effects to best performance'},
    @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\ThemeManager'; Name='ThemeActive'; Type='DWORD'; Value=1; Desc="Don't use visual styles on windows and buttons"},
    @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'; Name='WebView'; Type='DWORD'; Value=0; Desc="Don't use common tasks in folders"},
    @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'; Name='ListviewShadow'; Type='DWORD'; Value=0; Desc="Don't use drop shadows for icon labels"},
    @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'; Name='ListviewWatermark'; Type='DWORD'; Value=0; Desc="Don't use background image for folders"},
    @{Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'; Name='TaskbarAnimations'; Type='DWORD'; Value=0; Desc="Don't slide taskbar buttons"},
    @{Path='HKCU:\Control Panel\Desktop\WindowMetrics'; Name='MinAnimate'; Type='STRING'; Value='0'; Desc="Don't animate windows when minimizing/maximizing"},
    @{Path='HKCU:\Control Panel\Desktop'; Name='DragFullWindows'; Type='STRING'; Value='0'; Desc="Don't show window contents while dragging"},
    @{Path='HKCU:\Control Panel\Desktop'; Name='FontSmoothing'; Type='STRING'; Value='0'; Desc="Don't smooth edges of screen fonts"},
    @{Path='HKCU:\Control Panel\Desktop'; Name='UserPreferencesMask'; Type='BINARY'; Value=([byte[]](90,12,01,80)); Desc='Disable various UI animations'}
)

foreach ($tweak in $uiTweaks) {
    try {
        Set-ItemProperty -Path $tweak.Path -Name $tweak.Name -Type $tweak.Type -Value $tweak.Value
        Write-Log "Applied: $($tweak.Desc) ($($tweak.Path)\$($tweak.Name))"
    } catch {
        Write-Log "WARN Failed to apply: $($tweak.Desc) ($($tweak.Path)\$($tweak.Name)) - $($_.Exception.Message)"
    }
}

Write-Log "UI tweaks script completed."

try { Stop-Transcript | Out-Null } catch
{
    Write-Log "Failed to stop transcript logging: $($_.Exception.Message)"
}
