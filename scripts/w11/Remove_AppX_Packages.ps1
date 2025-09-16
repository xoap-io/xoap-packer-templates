$header = @'
<#
.SYNOPSIS
    Removes built-in and provisioned AppX packages from Windows Server 2025.

.DESCRIPTION
    This script disables the Microsoft Consumer Experience and removes unwanted AppX packages for all users.
    Developed and optimized for use with the XOAP Image Management module, but can be used independently.
    No liability is assumed for the function, use, or consequences of this freely available script.
    PowerShell is a product of Microsoft Corporation. XOAP is a product of RIS AG. © RIS AG

.COMPONENT
    PowerShell

.LINK
    https://github.com/xoap-io/xoap-packer-templates

#>
'@

$header
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

try {
    Write-Log 'Disabling the Microsoft Consumer Experience...'
    $cloudContentPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent'
    if (-not (Test-Path $cloudContentPath)) {
        New-Item -Path $cloudContentPath -Force | Out-Null
    }
    Set-ItemProperty -Path $cloudContentPath -Name DisableWindowsConsumerFeatures -Value 1

    # Import Appx module for PowerShell Core if needed
    $currentVersionKey = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
    $build = [int]$currentVersionKey.CurrentBuildNumber
    if (($PSVersionTable.PSEdition -ne 'Desktop') -and ($build -lt 22000)) {
        Import-Module Appx -UseWindowsPowerShell
    }

    # Remove all provisioned AppX packages
    Get-AppXProvisionedPackage -Online | ForEach-Object {
        Write-Log "Removing provisioned AppX package: $($_.PackageName)"
        try {
            $_ | Remove-AppxProvisionedPackage -Online | Out-Null
        } catch {
            Write-Log "WARN Failed to remove provisioned AppX: $($_.PackageName) - $($_.Exception.Message)"
        }
    }

    # Remove AppX packages for all users
    $appxPackages = @(
        'Clipchamp.Clipchamp',
        'Microsoft.549981C3F5F10',
        'Microsoft.BingNews',
        'Microsoft.BingWeather',
        'Microsoft.GamingApp',
        'Microsoft.GetHelp',
        'Microsoft.Getstarted',
        'Microsoft.Microsoft3DViewer',
        'Microsoft.MicrosoftOfficeHub',
        'Microsoft.MicrosoftSolitaireCollection',
        'Microsoft.MicrosoftStickyNotes',
        'Microsoft.MixedReality.Portal',
        'Microsoft.MSPaint',
        'Microsoft.Office.OneNote',
        'Microsoft.OneDriveSync',
        'Microsoft.Paint',
        'Microsoft.People',
        'Microsoft.PowerAutomateDesktop',
        'Microsoft.ScreenSketch',
        'Microsoft.Services.Store.Engagement',
        'Microsoft.SkypeApp',
        'Microsoft.StorePurchaseApp',
        'Microsoft.Todos',
        'Microsoft.Wallet',
        'Microsoft.Windows.Photos',
        'Microsoft.WindowsAlarms',
        'Microsoft.WindowsCalculator',
        'Microsoft.WindowsCamera',
        'microsoft.windowscommunicationsapps',
        'Microsoft.WindowsFeedbackHub',
        'Microsoft.WindowsMaps',
        'Microsoft.WindowsSoundRecorder',
        'Microsoft.WindowsStore',
        'Microsoft.Xbox.TCUI',
        'Microsoft.XboxApp',
        'Microsoft.XboxGameOverlay',
        'Microsoft.XboxGamingOverlay',
        'Microsoft.XboxIdentityProvider',
        'Microsoft.XboxSpeechToTextOverlay',
        'Microsoft.YourPhone',
        'Microsoft.ZuneMusic',
        'Microsoft.ZuneVideo',
        'MicrosoftCorporationII.QuickAssist',
        'MicrosoftWindows.Client.WebExperience',
        'MicrosoftTeams'
    )

    foreach ($pkg in $appxPackages) {
        $appx = Get-AppxPackage -AllUsers $pkg
        if ($appx) {
            Write-Log "Removing AppX package: $($appx.Name)"
            try {
                $appx | Remove-AppxPackage -AllUsers
            } catch {
                Write-Log "WARN Failed to remove AppX: $($appx.Name) - $($_.Exception.Message)"
            }
        } else {
            Write-Log "AppX package not installed: $pkg"
        }
    }

    Write-Log "AppX removal script completed."
} finally {
    try { Stop-Transcript | Out-Null } catch {
        Write-Log "Failed to stop transcript logging: $($_.Exception.Message)"
    }
}
