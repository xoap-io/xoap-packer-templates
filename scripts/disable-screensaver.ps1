<#
.SYNOPSIS
  Disables the screensaver.

.DESCRIPTION
  Disables the screensaver during the Packer build run

.OUTPUTS
  C:\Windows\Temp\disable-screensaver.log

.NOTES
  Version:        1.0
  Author:         XOAP
  Creation Date:  2022-05-11
  Purpose/Change: Initial script development

.EXAMPLE
  script = "../../scripts/disable-screensaver.ps1"
#>

#---[Initializations]-----------------------------------------------------------------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

#---[Variables and Declarations]------------------------------------------------------------------------------------------------------

#Script Version
[int]$ScriptVersion = "1.0"

#Log File Info
[string]$LogPath = "C:\Windows\Temp"
[string]$LogName = "disable-screensaver.log"
[string]$LogFile = Join-Path -Path $LogPath -ChildPath $LogName

#---[Execution]-----------------------------------------------------------------------------------------------------------------------

Start-Transcript -Append $LogFile

Set-ItemProperty "HKCU:\Control Panel\Desktop" -Name ScreenSaveActive -Value 0 -Type DWord
& powercfg -x -monitor-timeout-ac 0
& powercfg -x -monitor-timeout-dc 0

#---[Finish and Cleanup]--------------------------------------------------------------------------------------------------------------

Stop-Transcript
