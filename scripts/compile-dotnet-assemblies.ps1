<#
.SYNOPSIS
Optimize PowerShell startup by reduce JIT compile time with "ngen.exe"

.DESCRIPTION
Optimize PowerShell startup by reduce JIT compile time with "ngen.exe".

Script requires administrative permissions.

.OUTPUTS
  C:\Windows\Temp\compile-dotnet-assemblies.log

.NOTES
Version:        1.0
Author:         XOAP
Creation Date:  2022-05-11
Purpose/Change: Initial script development

.EXAMPLE
  script = "../../scripts/compile-dotnet-assemblies.ps1"

.LINK
https://github.com/BornToBeRoot/PowerShell/blob/master/Documentation/Script/OptimizePowerShellStartup.README.md

#>

#---[Initializations]-----------------------------------------------------------------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

#---[Variables and Declarations]------------------------------------------------------------------------------------------------------

#Script Version
[int]$ScriptVersion = "1.0"

#Log File Info
[string]$LogPath = "C:\Windows\Temp"
[string]$LogName = "compile-dotnet-assemblies.log"
[string]$LogFile = Join-Path -Path $LogPath -ChildPath $LogName

#---[Execution]-----------------------------------------------------------------------------------------------------------------------

Start-Transcript -Append $LogFile

Begin{

}

Process{
	# Restart script/console as admin with parameters
	if(-not([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
	{
		$Arguments = "& '" + $MyInvocation.MyCommand.Definition + "'"
		Start-Process PowerShell.exe -Verb RunAs -ArgumentList $Arguments
		Break
	}

	# Set ngen path
	$ngen_path = Join-Path -Path $env:windir -ChildPath "Microsoft.NET"

	if($env:PROCESSOR_ARCHITECTURE -eq "AMD64")
	{
		$ngen_path = Join-Path -Path $ngen_path -ChildPath "Framework64\ngen.exe"
	}
	else
	{
		$ngen_path = Join-Path -Path $ngen_path -ChildPath "Framework\ngen.exe"
	}

	# Find latest ngen.exe
	$ngen_application_path = (Get-ChildItem -Path $ngen_path -Filter "ngen.exe" -Recurse | Where-Object {$_.Length -gt 0} | Select-Object -Last 1).Fullname

	Set-Alias -Name ngen -Value $ngen_application_path

	# Get assemblies and call ngen.exe
	[System.AppDomain]::CurrentDomain.GetAssemblies() | foreach { ngen install $_.Location /nologo /verbose}

}

End{

}

#---[Finish and Cleanup]--------------------------------------------------------------------------------------------------------------

Stop-Transcript
