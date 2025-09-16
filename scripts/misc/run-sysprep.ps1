<#
.SYNOPSIS
  Runs Sysprep.

.DESCRIPTION
  Runs Sysprep during the Packer build run

.OUTPUTS
  C:\Windows\Temp\run-sysprep.log

.NOTES
  Version:        1.0
  Author:         XOAP
  Creation Date:  2022-05-11
  Purpose/Change: Initial script development

.EXAMPLE
  script = "../../scripts/run-sysprep.ps1"
#>

#---[Initializations]-----------------------------------------------------------------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

#---[Variables and Declarations]------------------------------------------------------------------------------------------------------

#Script Version
[int]$ScriptVersion = "1.0"

#Log File Info
[string]$LogPath = "C:\Windows\Temp"
[string]$LogName = "run-sysprep.log"
[string]$LogFile = Join-Path -Path $LogPath -ChildPath $LogName

#---[Execution]-----------------------------------------------------------------------------------------------------------------------

Start-Transcript -Append $LogFile

& c:\windows\system32\sysprep\sysprep.exe /generalize /oobe /mode:vm /quiet /quit

@('c:\unattend.xml', 'c:\windows\panther\unattend\unattend.xml', 'c:\windows\panther\unattend.xml', 'c:\windows\system32\sysprep\unattend.xml') | %{
	if (test-path $_){
		write-host "Removing $($_)"
		remove-item $_ > $null
	}
}

if (!(test-path 'c:\windows\panther\unattend')) {
	write-host "Creating directory $($_)"
    New-Item -path 'c:\windows\panther\unattend' -type directory > $null
}

if (Test-Path 'a:\unattend.xml'){
	Copy-Item 'a:\unattend.xml' 'c:\windows\panther\unattend\unattend.xml' > $null
} elseif (Test-Path 'e:\unattend.xml'){
	Copy-Item 'e:\unattend.xml' 'c:\windows\panther\unattend\unattend.xml' > $null
} else {
	Copy-Item 'f:\unattend.xml' 'c:\windows\panther\unattend\unattend.xml'> $null
}

& shutdown -s

exit 0

#---[Finish and Cleanup]--------------------------------------------------------------------------------------------------------------

Stop-Transcript
