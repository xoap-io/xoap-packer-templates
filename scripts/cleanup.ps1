<#
.SYNOPSIS
  Cleanup of files and directories created by the Packer build process.

.DESCRIPTION
  This script cleans up files and directories created by the Packer build

.OUTPUTS
  Log file stored in C:\Windows\Temp\cleanup.log

.NOTES
  Version:        1.0
  Author:         XOAP
  Creation Date:  2022-05-11
  Purpose/Change: Initial script development

.EXAMPLE
  script = "../../scripts/cleanup.ps1"
#>

#---[Initializations]-----------------------------------------------------------------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

#---[Variables and Declarations]------------------------------------------------------------------------------------------------------

#Script Version
[int]$ScriptVersion = "1.0"

#Log File Info
[string]$LogPath = "C:\Windows\Temp"
[string]$LogName = "cleanup.log"
[string]$LogFile = Join-Path -Path $LogPath -ChildPath $LogName

#---[Execution]-----------------------------------------------------------------------------------------------------------------------

Start-Transcript -Append $LogFile

$tempfolders = @("C:\Windows\Prefetch\*", "C:\Documents and Settings\*\Local Settings\temp\*", "C:\Users\*\Appdata\Local\Temp\*")

Remove-Item $tempfolders -ErrorAction SilentlyContinue -Force -Recurse

#---[Finish and Cleanup]--------------------------------------------------------------------------------------------------------------

Stop-Transcript
