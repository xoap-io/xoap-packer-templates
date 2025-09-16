<#
.SYNOPSIS
    Installs VMware Tools on Windows Server 2025

.DESCRIPTION
    This script installs or reinstalls VMware Tools, verifies service status, and logs all actions.
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

param (
    [string]$SetupPath = "E:",
    [int]$MaxRetries = 5,
    [int]$RetryInterval = 2
)

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

$VMToolsName = "VMware Tools"
$VMToolsServiceName = "VMTools"

function Test-VMToolsInstalled {
    try {
        $vmToolsService = Get-WmiObject -Class Win32_Service -Filter "Name='$VMToolsServiceName'" -ErrorAction SilentlyContinue
        if ($vmToolsService) { return $true }
        $registryPaths = @(
            "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
            "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
        )
        foreach ($path in $registryPaths) {
            try {
                $vmToolsFound = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue |
                               Where-Object { $_.DisplayName -like "*VMware Tools*" } |
                               Select-Object -First 1
                if ($vmToolsFound) { return $true }
            } catch {
                Write-Log "Warning: Could not access registry path ${path}: $($_.Exception.Message)"
            }
        }
        return $false
    } catch {
        Write-Log "Warning: Error checking VMware Tools installation: $($_.Exception.Message)"
        return $false
    }
}

function Test-VMToolsService {
    Write-Log 'Checking VMware Tools service status...'
    for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
        try {
            $service = Get-Service -Name $VMToolsServiceName -ErrorAction Stop
            if ($service.Status -eq "Running") {
                Write-Log "VMware Tools service is running (attempt $attempt/$MaxRetries)"
                return $true
            }
            if ($service.Status -eq "Stopped") {
                Write-Log "Attempting to start VMware Tools service..."
                try {
                    Start-Service -Name $VMToolsServiceName -ErrorAction Stop
                    Start-Sleep -Seconds 3
                    continue
                } catch {
                    Write-Log "Warning: Failed to start service: $($_.Exception.Message)"
                }
            }
            Write-Log "Service status: $($service.Status). Retry $attempt/$MaxRetries"
        } catch {
            Write-Log "Warning: Service check failed (attempt $attempt/$MaxRetries): $($_.Exception.Message)"
        }
        if ($attempt -lt $MaxRetries) {
            Start-Sleep -Seconds $RetryInterval
        }
    }
    Write-Log "Warning: VMware Tools service is not running after $MaxRetries attempts"
    return $false
}

function Install-VMwareTools {
    Write-Log "Locating VMware Tools installer in: $SetupPath"
    $installerPath = $null
    if (Test-Path "$SetupPath\setup64.exe") {
        $installerPath = "$SetupPath\setup64.exe"
    } elseif (Test-Path "$SetupPath\setup.exe") {
        $installerPath = "$SetupPath\setup.exe"
    } else {
        $availableFiles = Get-ChildItem -Path $SetupPath -Filter "*.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
        Write-Log "ERROR: VMware Tools installer not found. Available files: $($availableFiles -join ', ')"
        return $false
    }
    Write-Log "Installing VMware Tools using: $installerPath"
    try {
        $process = Start-Process -FilePath $installerPath -ArgumentList '/s /v "/qb REBOOT=R"' -Wait -PassThru -NoNewWindow
        if ($process.ExitCode -eq 0) {
            Write-Log "VMware Tools installation completed successfully"
            Start-Sleep -Seconds 5
            return $true
        } else {
            Write-Log "ERROR: Installation failed with exit code: $($process.ExitCode)"
            return $false
        }
    } catch {
        Write-Log "ERROR: VMware Tools installation failed: $($_.Exception.Message)"
        return $false
    }
}

function Uninstall-VMwareTools {
    Write-Log "Attempting to uninstall existing VMware Tools..."
    try {
        $uninstallKeys = @(
            "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
            "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
        )
        $vmToolsEntry = $null
        foreach ($path in $uninstallKeys) {
            try {
                $vmToolsEntry = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue |
                               Where-Object { $_.DisplayName -like "*$VMToolsName*" } |
                               Select-Object -First 1
                if ($vmToolsEntry) { break }
            } catch {
                Write-Log "Warning: Could not access uninstall registry path: $($_.Exception.Message)"
            }
        }
        if ($vmToolsEntry -and $vmToolsEntry.PSChildName) {
            Write-Log "Uninstalling via MSI GUID: $($vmToolsEntry.PSChildName)"
            $process = Start-Process -FilePath "msiexec.exe" -ArgumentList "/X $($vmToolsEntry.PSChildName) /quiet /norestart" -Wait -PassThru -NoNewWindow
            if ($process.ExitCode -ne 0) {
                Write-Log "Warning: MSI uninstall returned exit code: $($process.ExitCode)"
            }
        }
        try {
            Stop-Service -Name $VMToolsServiceName -Force -ErrorAction SilentlyContinue
            Write-Log "Stopped VMware Tools service"
        } catch {
            Write-Log "Warning: Service stop failed: $($_.Exception.Message)"
        }
        Start-Sleep -Seconds 3
        Write-Log "Uninstallation process completed"
        return $true
    } catch {
        Write-Log "Warning: Uninstallation failed: $($_.Exception.Message)"
        return $false
    }
}

# Main execution logic
Write-Log 'Starting VMware Tools installation script...'

if (Test-VMToolsInstalled) {
    Write-Log "VMware Tools is currently installed"
    if (Test-VMToolsService) {
        Write-Log "VMware Tools is properly installed and running"
        try { Stop-Transcript | Out-Null } catch {}
        Exit 0
    } else {
        Write-Log "VMware Tools service is not running properly. Initiating reinstallation..."
        if (Uninstall-VMwareTools) {
            Write-Log "Successfully uninstalled existing VMware Tools"
        } else {
            Write-Log "Warning: Uninstallation completed with warnings. Proceeding with installation..."
        }
    }
} else {
    Write-Log "VMware Tools is not installed. Proceeding with fresh installation..."
}

Write-Log "Starting VMware Tools installation..."
if (-not (Install-VMwareTools)) {
    Write-Log "ERROR: Failed to install VMware Tools"
    try { Stop-Transcript | Out-Null } catch {}
    Exit 1
}

Write-Log "Performing post-installation verification..."
if (Test-VMToolsService) {
    Write-Log "VMware Tools successfully installed and running."
} else {
    Write-Log "ERROR: VMware Tools installed but service verification failed"
    try { Stop-Transcript | Out-Null } catch {}
    Exit 1
}

try { Stop-Transcript | Out-Null } catch {}
