<#
.SYNOPSIS
  Fixes the netowrk connections for WinRM.

.DESCRIPTION
  You cannot enable Windows PowerShell Remoting on network connections that are set to Public
  Spin through all the network locations and if they are set to Public, set them to Private
  using the INetwork interface:
  http://msdn.microsoft.com/en-us/library/windows/desktop/aa370750(v=vs.85).aspx
  For more info, see:
  http://blogs.msdn.com/b/powershell/archive/2009/04/03/setting-network-location-to-private.aspx

.OUTPUTS
  C:\Windows\Temp\enable-rdp.log

.NOTES
  Version:        1.0
  Author:         XOAP
  Creation Date:  2022-05-11
  Purpose/Change: Initial script development

.EXAMPLE
  script = "../../scripts/fix-network.ps1"
#>

#---[Initializations]-----------------------------------------------------------------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

#---[Variables and Declarations]------------------------------------------------------------------------------------------------------

#Script Version
[int]$ScriptVersion = "1.0"

#Log File Info
[string]$LogPath = "C:\Windows\Temp"
[string]$LogName = "fix-network.log"
[string]$LogFile = Join-Path -Path $LogPath -ChildPath $LogName

#---[Execution]-----------------------------------------------------------------------------------------------------------------------

Start-Transcript -Append $LogFile

function Set-NetworkTypeToPrivate {
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPositionalParameters', '')]
  param()
  # Network location feature was only introduced in Windows Vista - no need to bother with this
  # if the operating system is older than Vista
  if ([environment]::OSVersion.version.Major -lt 6) { return }

  # You cannot change the network location if you are joined to a domain, so abort
  if (1, 3, 4, 5 -contains (Get-CimInstance win32_computersystem).DomainRole) { return }

  # Get network connections
  $networkListManager = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))
  $connections = $networkListManager.GetNetworkConnections()

  $connections | ForEach-Object {
    Write-Output $_.GetNetwork().GetName() "category was previously set to" $_.GetNetwork().GetCategory()
    #$_.GetNetwork().SetCategory(1)
    Write-Output $_.GetNetwork().GetName() "changed to category" $_.GetNetwork().GetCategory()
  }

}

Set-NetworkTypeToPrivate

#---[Finish and Cleanup]--------------------------------------------------------------------------------------------------------------

Stop-Transcript
