<#
.SYNOPSIS
    Optimizes .NET assemblies by compiling them with ngen.exe

.DESCRIPTION
    This script locates ngen.exe, compiles loaded .NET assemblies, and updates the native image cache for performance. Includes robust logging, error handling, and admin elevation.
    Developed for use with XOAP Image Management, but can be used independently.
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

function Test-IsAdmin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]$currentUser
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-NgenPath {
    $basePath = Join-Path -Path $env:windir -ChildPath "Microsoft.NET"

    if ($env:PROCESSOR_ARCHITECTURE -eq "AMD64") {
        $searchPath = Join-Path -Path $basePath -ChildPath "Framework64"
    } else {
        $searchPath = Join-Path -Path $basePath -ChildPath "Framework"
    }

    # Find latest ngen.exe
    try {
        $ngenExe = Get-ChildItem -Path $searchPath -Filter "ngen.exe" -Recurse -ErrorAction Stop |
                   Where-Object { $_.Length -gt 0 } |
                   Sort-Object FullName |
                   Select-Object -Last 1

        if (-not $ngenExe) {
            throw "ngen.exe not found in $searchPath"
        }

        return $ngenExe.FullName
    } catch {
        throw "Failed to locate ngen.exe: $($_.Exception.Message)"
    }
}

try {
    Write-Log 'Starting .NET assembly compilation optimization'

    # Check if running as administrator
    if (-not (Test-IsAdmin)) {
        Write-Log 'Script requires administrative privileges. Attempting to restart as administrator...'
        try {
            $Arguments = "& '$($MyInvocation.MyCommand.Definition)'"
            Start-Process PowerShell.exe -Verb RunAs -ArgumentList $Arguments -Wait
            Write-Log 'Script executed with administrative privileges.'
            exit 0
        } catch {
            Write-Log "ERROR: Failed to restart as administrator: $($_.Exception.Message)"
            exit 1
        }
    }

    # Get ngen.exe path
    try {
        $ngenPath = Get-NgenPath
    Write-Log "Found ngen.exe at: $ngenPath"
    } catch {
        Write-Log "ERROR: $($_.Exception.Message)"
        exit 1
    }

    # Get loaded assemblies and compile them
    Write-Log 'Retrieving currently loaded .NET assemblies'
    try {
        $assemblies = [System.AppDomain]::CurrentDomain.GetAssemblies()
    Write-Log "Found $($assemblies.Count) loaded assemblies"

        $successCount = 0
        $failureCount = 0

        foreach ($assembly in $assemblies) {
            try {
                $location = $assembly.Location
                if ([string]::IsNullOrEmpty($location)) {
                    Write-Log "Skipping assembly with no location: $($assembly.FullName)"
                    continue
                }

                Write-Log "Compiling: $location"
                $result = & $ngenPath install $location /nologo 2>&1

                if ($LASTEXITCODE -eq 0) {
                    $successCount++
                    Write-Log "Successfully compiled: $($assembly.GetName().Name)"
                } else {
                    $failureCount++
                    Write-Log "Warning: Failed to compile $($assembly.GetName().Name): $result"
                }
            } catch {
                $failureCount++
                Write-Log "Warning: Could not compile $($assembly.GetName().Name): $($_.Exception.Message)"
            }
        }

    Write-Log "Compilation complete. Success: $successCount, Failures: $failureCount"

        if ($successCount -gt 0) {
            Write-Log 'Running ngen.exe update to optimize compiled images'
            try {
                & $ngenPath update /nologo
                if ($LASTEXITCODE -eq 0) {
                    Write-Log 'Successfully updated native image cache'
                } else {
                    Write-Log 'Warning: ngen update returned non-zero exit code'
                }
            } catch {
                Write-Log "Warning: Could not update native image cache: $($_.Exception.Message)"
            }
        }

    } catch {
    Write-Log "Warning: Could not process assemblies: $($_.Exception.Message)"
        exit 1
    }

    Write-Log '.NET assembly compilation optimization completed successfully'

} finally {
    if (Get-Command Stop-LogScope -ErrorAction SilentlyContinue) {
        Stop-LogScope
    }
}
