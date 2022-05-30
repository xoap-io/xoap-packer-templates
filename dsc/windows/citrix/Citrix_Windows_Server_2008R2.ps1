Configuration Citrix_Windows_Server_2008R2{

            Import-DSCResource -ModuleName "PSDesiredStateConfiguration"
            Import-DSCResource -ModuleName "AuditPolicyDSC"
            Import-DSCResource -ModuleName "SecurityPolicyDSC"
            Import-DSCResource -ModuleName "DSCR_AppxPackage"
            Import-DSCResource -ModuleName "ComputerManagementDsc"

            Node localhost
            {


    Write-Verbose "Service ALG will be Disabled."
    Service "ALG"{
    Name        = "ALG"
    State       = "stopped"
    StartupType = "Disabled"
}


    Write-Verbose "Service Browser will be Disabled."
    Service "Browser"{
    Name        = "Browser"
    State       = "stopped"
    StartupType = "Disabled"
}


    Write-Verbose "Service DPS will be Disabled."
    Service "DPS"{
    Name        = "DPS"
    State       = "stopped"
    StartupType = "Disabled"
}


    Write-Verbose "Service WdiServiceHost will be Disabled."
    Service "WdiServiceHost"{
    Name        = "WdiServiceHost"
    State       = "stopped"
    StartupType = "Disabled"
}


    Write-Verbose "Service WdiSystemHost will be Disabled."
    Service "WdiSystemHost"{
    Name        = "WdiSystemHost"
    State       = "stopped"
    StartupType = "Disabled"
}


    Write-Verbose "Service EFS will be Disabled."
    Service "EFS"{
    Name        = "EFS"
    State       = "stopped"
    StartupType = "Disabled"
}


    Write-Verbose "Service fdPHost will be Disabled."
    Service "fdPHost"{
    Name        = "fdPHost"
    State       = "stopped"
    StartupType = "Disabled"
}


    Write-Verbose "Service FDResPub will be Disabled."
    Service "FDResPub"{
    Name        = "FDResPub"
    State       = "stopped"
    StartupType = "Disabled"
}


    Write-Verbose "Service SharedAccess will be Disabled."
    Service "SharedAccess"{
    Name        = "SharedAccess"
    State       = "stopped"
    StartupType = "Disabled"
}


    Write-Verbose "Service SSDPSRV will be Disabled."
    Service "SSDPSRV"{
    Name        = "SSDPSRV"
    State       = "stopped"
    StartupType = "Disabled"
}


    Write-Verbose "Service upnphost will be Disabled."
    Service "upnphost"{
    Name        = "upnphost"
    State       = "stopped"
    StartupType = "Disabled"
}


    Write-Verbose "Service Themes will be Disabled."
    Service "Themes"{
    Name        = "Themes"
    State       = "stopped"
    StartupType = "Disabled"
}


    Write-Verbose "Service WerSvc will be Disabled."
    Service "WerSvc"{
    Name        = "WerSvc"
    State       = "stopped"
    StartupType = "Disabled"
}


    Write-Verbose "Service DiagTrack will be Automatic."
    Service "DiagTrack"{
    Name        = "DiagTrack"
    State       = "stopped"
    StartupType = "Automatic"
}


    Write-Verbose "Service defragsvc will be Manual."
    Service "defragsvc"{
    Name        = "defragsvc"
    State       = "stopped"
    StartupType = "Manual"
}


    Write-Verbose "Service ShellHWDetection will be Automatic."
    Service "ShellHWDetection"{
    Name        = "ShellHWDetection"
    State       = "stopped"
    StartupType = "Automatic"
}


    Write-Verbose "Scheduled Task AnalyzeSystem will be Disabled."
    ScheduledTask "AnalyzeSystem"
{
    TaskName            = "AnalyzeSystem"
    TaskPath            = "\Microsoft\Windows\Power Efficiency Diagnostics"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task AitAgent will be Disabled."
    ScheduledTask "AitAgent"
{
    TaskName            = "AitAgent"
    TaskPath            = "\Microsoft\Windows\Application Experience"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task BfeOnServiceStartTypeChange will be Disabled."
    ScheduledTask "BfeOnServiceStartTypeChange"
{
    TaskName            = "BfeOnServiceStartTypeChange"
    TaskPath            = "\Microsoft\Windows\Windows Filtering Platform"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task Consolidator will be Disabled."
    ScheduledTask "Consolidator"
{
    TaskName            = "Consolidator"
    TaskPath            = "\Microsoft\Windows\Customer Experience Improvement Program"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task ServerCeipAssistant will be Disabled."
    ScheduledTask "ServerCeipAssistant"
{
    TaskName            = "ServerCeipAssistant"
    TaskPath            = "\Microsoft\Windows\Customer Experience Improvement Program\Server"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task ServerRoleCollector will be Disabled."
    ScheduledTask "ServerRoleCollector"
{
    TaskName            = "ServerRoleCollector"
    TaskPath            = "\Microsoft\Windows\Customer Experience Improvement Program\Server"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task ServerRoleCollector-RunOnce will be Disabled."
    ScheduledTask "ServerRoleCollector-RunOnce"
{
    TaskName            = "ServerRoleCollector-RunOnce"
    TaskPath            = "\Microsoft\Windows\Customer Experience Improvement Program\Server"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task ServerRoleUsageCollector will be Disabled."
    ScheduledTask "ServerRoleUsageCollector"
{
    TaskName            = "ServerRoleUsageCollector"
    TaskPath            = "\Microsoft\Windows\Customer Experience Improvement Program\Server"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task Microsoft-Windows-DiskDiagnosticDataCollector will be Disabled."
    ScheduledTask "Microsoft-Windows-DiskDiagnosticDataCollector"
{
    TaskName            = "Microsoft-Windows-DiskDiagnosticDataCollector"
    TaskPath            = "\Microsoft\Windows\DiskDiagnostic"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task Microsoft-Windows-DiskDiagnosticResolver will be Disabled."
    ScheduledTask "Microsoft-Windows-DiskDiagnosticResolver"
{
    TaskName            = "Microsoft-Windows-DiskDiagnosticResolver"
    TaskPath            = "\Microsoft\Windows\DiskDiagnostic"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task KernelCeipTask will be Disabled."
    ScheduledTask "KernelCeipTask"
{
    TaskName            = "KernelCeipTask"
    TaskPath            = "\Microsoft\Windows\Customer Experience Improvement Program"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task ProactiveScan will be Disabled."
    ScheduledTask "ProactiveScan"
{
    TaskName            = "ProactiveScan"
    TaskPath            = "\Microsoft\Windows\CHKDSK"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task ProgramDataUpdater will be Disabled."
    ScheduledTask "ProgramDataUpdater"
{
    TaskName            = "ProgramDataUpdater"
    TaskPath            = "\Microsoft\Windows\Application Experience"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task Proxy will be Disabled."
    ScheduledTask "Proxy"
{
    TaskName            = "Proxy"
    TaskPath            = "\Microsoft\Windows\Autochk"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task RegIdleBackup will be Disabled."
    ScheduledTask "RegIdleBackup"
{
    TaskName            = "RegIdleBackup"
    TaskPath            = "\Microsoft\Windows\Registry"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task ResolutionHost will be Disabled."
    ScheduledTask "ResolutionHost"
{
    TaskName            = "ResolutionHost"
    TaskPath            = "\Microsoft\Windows\WDI"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task ScheduledDefrag will be Disabled."
    ScheduledTask "ScheduledDefrag"
{
    TaskName            = "ScheduledDefrag"
    TaskPath            = "\Microsoft\Windows\Defrag"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task ServerManager will be Disabled."
    ScheduledTask "ServerManager"
{
    TaskName            = "ServerManager"
    TaskPath            = "\Microsoft\Windows\Server Manager"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task UsbCeip will be Disabled."
    ScheduledTask "UsbCeip"
{
    TaskName            = "UsbCeip"
    TaskPath            = "\Microsoft\Windows\Customer Experience Improvement Program"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task QueueReporting will be Disabled."
    ScheduledTask "QueueReporting"
{
    TaskName            = "QueueReporting"
    TaskPath            = "\Microsoft\Windows\Windows Error Reporting"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Scheduled Task ServerManager will be Disabled."
    ScheduledTask "ServerManager"
{
    TaskName            = "ServerManager"
    TaskPath            = "\Microsoft\Windows\Server Manager"
    Enable              = [bool]$false
    Ensure              = "Absent"
}


    Write-Verbose "Registry Key EnableAutoLayout will be set to: 0."
Registry "EnableAutoLayout"
{
    Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OptimalLayout"
    Ensure      = "Present"
    ValueName   = "EnableAutoLayout"
    ValueType   = "DWORD"
    ValueData   = "0"
}


    Write-Verbose "Registry Key Enable will be set to: N."
Registry "Enable"
{
    Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction"
    Ensure      = "Present"
    ValueName   = "Enable"
    ValueType   = "String"
    ValueData   = "N"
}


    Write-Verbose "Registry Key ScreenSaveActive will be set to: 0."
Registry "ScreenSaveActive"
{
    Key         = "HKEY_USERS\.DEFAULT\Control Panel\Desktop"
    Ensure      = "Present"
    ValueName   = "ScreenSaveActive"
    ValueType   = "DWORD"
    ValueData   = "0"
}


    Write-Verbose "Registry Key CrashDumpEnabled will be set to: 0."
Registry "CrashDumpEnabled"
{
    Key         = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl"
    Ensure      = "Present"
    ValueName   = "CrashDumpEnabled"
    ValueType   = "DWORD"
    ValueData   = "0"
}


    Write-Verbose "Registry Key NtfsDisableLastAccessUpdate will be set to: 1."
Registry "NtfsDisableLastAccessUpdate"
{
    Key         = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem"
    Ensure      = "Present"
    ValueName   = "NtfsDisableLastAccessUpdate"
    ValueType   = "DWORD"
    ValueData   = "1"
}


    Write-Verbose "Registry Key EnableFirstLogonAnimation will be set to: 0."
Registry "EnableFirstLogonAnimation"
{
    Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    Ensure      = "Present"
    ValueName   = "EnableFirstLogonAnimation"
    ValueType   = "DWORD"
    ValueData   = "0"
}


    Write-Verbose "Registry Key ErrorMode will be set to: 2."
Registry "ErrorMode"
{
    Key         = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Windows"
    Ensure      = "Present"
    ValueName   = "ErrorMode"
    ValueType   = "DWORD"
    ValueData   = "2"
}


    Write-Verbose "Registry Key TimeOutValue will be set to: 0x000000C8."
Registry "TimeOutValue"
{
    Key         = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Disk"
    Ensure      = "Present"
    ValueName   = "TimeOutValue"
    ValueType   = "DWORD"
    ValueData   = "0x000000C8"
}


    Write-Verbose "Registry Key NoAutoUpdate will be set to: 1."
Registry "NoAutoUpdate"
{
    Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    Ensure      = "Present"
    ValueName   = "NoAutoUpdate"
    ValueType   = "DWORD"
    ValueData   = "1"
}


        }
        }
        Citrix_Windows_Server_2008R2
