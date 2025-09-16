<#
.SYNOPSIS
    Performs final cleanup and prepares Windows Server 2025 for sysprep

.DESCRIPTION
    This script performs final cleanup tasks and prepares the system for sysprep and imaging on Windows Server 2025.
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

# Simple logging function
function Write-Log {
    param($Message)
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

try {
    Write-Log 'Starting final cleanup and sysprep'
     
    # Defragment system drive
    Write-Log 'Optimizing system drive...'
    try {
        Optimize-Volume -DriveLetter C -Defrag -Verbose:$false
        Write-Log 'System drive optimization completed'
    } catch {
        Write-Log "Warning: Could not optimize system drive: $($_.Exception.Message)"
    }
    
    Write-Log 'Final cleanup completed, preparing for sysprep...'
      
    # Stop transcript before sysprep
    try { Stop-Transcript | Out-Null } catch {}
    
    # Prepare sysprep command
    $sysprepPath = Join-Path $env:WINDIR "System32\Sysprep\sysprep.exe"
    $sysprepArgs = @('/generalize', '/oobe')
    
    Write-Log "Running sysprep with arguments: $($sysprepArgs -join ' ')"
    Write-Log "This will shutdown the system when complete"
    
        # Check if sysprep.exe exists
        if (Test-Path $sysprepPath) {
            # Run sysprep using Start-Process for better error handling
            $process = Start-Process -FilePath $sysprepPath -ArgumentList $sysprepArgs -Wait -PassThru
            $exitCode = $process.ExitCode
            if ($null -eq $exitCode) {
                # Fallback to $LASTEXITCODE if ExitCode is not set
                $exitCode = $LASTEXITCODE
            }
            if ($exitCode -ne 0) {
                Write-Log "Sysprep failed with exit code: $exitCode"
                exit $exitCode
            }
        } else {
            Write-Log "Sysprep executable not found at $sysprepPath"
            exit 1
        }
    
} catch {
    Write-Log "Critical error in final cleanup: $($_.Exception.Message)"
    try { Stop-Transcript | Out-Null } catch {}
    throw
}
