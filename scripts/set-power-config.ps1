<#
.SYNOPSIS
  Set Power Config.

.DESCRIPTION
  Sets the power configuration during the Packer build run

.OUTPUTS
  C:\Windows\Temp\set-power-config.log

.NOTES
  Version:        1.0
  Author:         XOAP
  Creation Date:  2022-05-11
  Purpose/Change: Initial script development

.EXAMPLE
  script = "../../scripts/set-power-config.ps1"
#>

#---[Initializations]-----------------------------------------------------------------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

#---[Variables and Declarations]------------------------------------------------------------------------------------------------------

#Script Version
[int]$ScriptVersion = "1.0"

#Log File Info
[string]$LogPath = "C:\Windows\Temp"
[string]$LogName = "set-power-config.log"
[string]$LogFile = Join-Path -Path $LogPath -ChildPath $LogName

#---[Execution]-----------------------------------------------------------------------------------------------------------------------

Start-Transcript -Append $LogFile

#Set power configuration to High Performance
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
#Monitor timeout
powercfg -Change -monitor-timeout-ac 0
powercfg -Change -monitor-timeout-dc 0
powercfg -hibernate OFF

#---[Finish and Cleanup]--------------------------------------------------------------------------------------------------------------

Stop-Transcript
