<#
.SYNOPSIS
    Removes OneDrive and Teams from Windows Server 2025.

.DESCRIPTION
    This script removes OneDrive and Teams, cleans up leftovers, disables related policies, and clears caches.
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

function force-mkdir($path) {
    if (!(Test-Path $path)) {
        New-Item -ItemType Directory -Force -Path $path | Out-Null
    }
}

function Takeown-Folder($path) {
    takeown.exe /A /F $path
    $acl = Get-Acl $path
    $admins = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
    $admins = $admins.Translate([System.Security.Principal.NTAccount])
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($admins, "FullControl", "None", "None", "Allow")
    $acl.AddAccessRule($rule)
    Set-Acl -Path $path -AclObject $acl
    foreach ($item in Get-ChildItem $path) {
        if (Test-Path $item -PathType Container) {
            Takeown-Folder $item.FullName
        } else {
            takeown.exe /A /F $item.FullName
            $itemAcl = Get-Acl $item.FullName
            $itemAcl.AddAccessRule($rule)
            Set-Acl -Path $item.FullName -AclObject $itemAcl
        }
    }
}

function unInstallTeams($path) {
    $clientInstaller = "$($path)\Update.exe"
    try {
        $process = Start-Process -FilePath "$clientInstaller" -ArgumentList "--uninstall /s" -PassThru -Wait -ErrorAction Stop
        if ($process.ExitCode -ne 0) {
            Write-Log "Teams uninstallation failed with exit code $($process.ExitCode)."
        } else {
            Write-Log "Teams uninstalled from $path."
        }
    } catch {
        Write-Log "Teams uninstall error: $($_.Exception.Message)"
    }
}

try {
    Write-Log 'Stopping OneDrive and Explorer processes...'
    taskkill.exe /F /IM "OneDrive.exe"
    taskkill.exe /F /IM "explorer.exe"

    Write-Log 'Uninstalling OneDrive...'
    foreach ($exe in @("$env:systemroot\System32\OneDriveSetup.exe", "$env:systemroot\SysWOW64\OneDriveSetup.exe")) {
        if (Test-Path $exe) {
            & $exe /uninstall
            Write-Log "Ran $exe /uninstall"
        }
    }

    Write-Log 'Disabling OneDrive via Group Policies...'
    force-mkdir "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive"
    Set-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive" -Name DisableFileSyncNGSC -Value 1

    Write-Log 'Removing OneDrive leftovers...'
    foreach ($path in @(
        "$env:localappdata\Microsoft\OneDrive",
        "$env:programdata\Microsoft OneDrive",
        "C:\OneDriveTemp"
    )) {
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $path
        Write-Log "Removed $path"
    }

    Write-Log 'Removing OneDrive from explorer sidebar...'
    New-PSDrive -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR"
    foreach ($regPath in @(
        "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}",
        "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
    )) {
        mkdir -Force $regPath | Out-Null
        Set-ItemProperty $regPath -Name System.IsPinnedToNameSpaceTree -Value 0
        Write-Log "Set System.IsPinnedToNameSpaceTree=0 for $regPath"
    }
    Remove-PSDrive "HKCR"

    Write-Log 'Removing OneDrive run option for new users...'
    reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
    reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
    reg unload "hku\Default"

    Write-Log 'Removing OneDrive Start Menu shortcut...'
    Remove-Item -Force -ErrorAction SilentlyContinue "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

    Write-Log 'Restarting Explorer...'
    Start-Process "explorer.exe"
    Start-Sleep -Seconds 15

    Write-Log 'Removing additional OneDrive leftovers from WinSxS...'
    foreach ($item in Get-ChildItem "$env:WinDir\WinSxS\*onedrive*") {
        Takeown-Folder $item.FullName
        Remove-Item -Recurse -Force $item.FullName -ErrorAction SilentlyContinue
        Write-Log "Removed $($item.FullName)"
    }

    Write-Log 'Removing Teams...'
    try {
        Get-Process -ProcessName Teams -ErrorAction SilentlyContinue | Stop-Process -Force
        Write-Log "Teams process stopped."
    } catch {
        Write-Log "Teams process stop error: $($_.Exception.Message)"
    }

    Write-Log 'Clearing Teams disk cache...'
    foreach ($cachePath in @(
        "$env:APPDATA\Microsoft\teams\application cache\cache",
        "$env:APPDATA\Microsoft\teams\blob_storage",
        "$env:APPDATA\Microsoft\teams\databases",
        "$env:APPDATA\Microsoft\teams\cache",
        "$env:APPDATA\Microsoft\teams\gpucache",
        "$env:APPDATA\Microsoft\teams\Indexeddb",
        "$env:APPDATA\Microsoft\teams\Local Storage",
        "$env:APPDATA\Microsoft\teams\tmp"
    )) {
        Get-ChildItem -Path $cachePath -ErrorAction SilentlyContinue | Remove-Item -Confirm:$false -ErrorAction SilentlyContinue
        Write-Log "Cleared Teams cache: $cachePath"
    }

    Write-Log 'Stopping IE and Edge processes...'
    foreach ($proc in @('MicrosoftEdge', 'IExplore')) {
        try {
            Get-Process -ProcessName $proc -ErrorAction SilentlyContinue | Stop-Process -Force
            Write-Log "$proc process stopped."
        } catch {
            Write-Log "$proc process stop error: $($_.Exception.Message)"
        }
    }

    Write-Log 'Clearing IE and Edge cache...'
    try {
        RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 8
        RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 2
        Write-Log "IE and Edge cache cleared."
    } catch {
        Write-Log "IE/Edge cache clear error: $($_.Exception.Message)"
    }

    Write-Log 'Removing Teams Machine-wide Installer...'
    try {
        $MachineWide = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "Teams Machine-Wide Installer" }
        if ($MachineWide) {
            $MachineWide.Uninstall()
            Write-Log "Teams Machine-Wide Installer uninstalled."
        }
    } catch {
        Write-Log "Teams Machine-Wide Installer uninstall error: $($_.Exception.Message)"
    }

    Write-Log 'Uninstalling Teams client...'
    $localAppData = "$env:LOCALAPPDATA\Microsoft\Teams"
    $programData = "$env:ProgramData\$env:USERNAME\Microsoft\Teams"
    if (Test-Path "$localAppData\Current\Teams.exe") {
        unInstallTeams($localAppData)
    } elseif (Test-Path "$programData\Current\Teams.exe") {
        unInstallTeams($programData)
    } else {
        Write-Log "Teams installation not found."
    }

    Write-Log "Cleanup Complete."
} finally {
    try { Stop-Transcript | Out-Null } catch {
        Write-Log "Failed to stop transcript logging: $($_.Exception.Message)"
    }
}
