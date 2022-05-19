Configuration citrix-optimizer-windows-8 {

Import-DSCResource -ModuleName "PSDesiredStateConfiguration"
Import-DSCResource -ModuleName "ComputerManagementDsc"

    Node citrix-optimizer-windows-8
    {

        Write-Verbose "Service ALG will be Disabled."
        Service "ALG"{
        Name        = "ALG"
        State       = "stopped"
        StartupType = "Disabled"
        }

        Write-Verbose "Service BDESVC will be Disabled."
        Service "BDESVC"{
        Name        = "BDESVC"
        State       = "stopped"
        StartupType = "Disabled"
        }

        Write-Verbose "Service wbengine will be Disabled."
        Service "wbengine"{
        Name        = "wbengine"
        State       = "stopped"
        StartupType = "Disabled"
        }

        Write-Verbose "Service BthHFSrv will be Disabled."
        Service "BthHFSrv"{
        Name        = "BthHFSrv"
        State       = "stopped"
        StartupType = "Disabled"
        }

        Write-Verbose "Service bthserv will be Disabled."
        Service "bthserv"{
        Name        = "bthserv"
        State       = "stopped"
        StartupType = "Disabled"
        }

        Write-Verbose "Service PeerDistSvc will be Disabled."
        Service "PeerDistSvc"{
        Name        = "PeerDistSvc"
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

        Write-Verbose "Service Fax will be Disabled."
        Service "Fax"{
        Name        = "Fax"
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

        Write-Verbose "Service HomeGroupListener will be Disabled."
        Service "HomeGroupListener"{
        Name        = "HomeGroupListener"
        State       = "stopped"
        StartupType = "Disabled"
        }

        Write-Verbose "Service HomeGroupProvider will be Disabled."
        Service "HomeGroupProvider"{
        Name        = "HomeGroupProvider"
        State       = "stopped"
        StartupType = "Disabled"
        }

        Write-Verbose "Service SharedAccess will be Disabled."
        Service "SharedAccess"{
        Name        = "SharedAccess"
        State       = "stopped"
        StartupType = "Disabled"
        }

        Write-Verbose "Service CscService will be Disabled."
        Service "CscService"{
        Name        = "CscService"
        State       = "stopped"
        StartupType = "Disabled"
        }

        Write-Verbose "Service wscsvc will be Disabled."
        Service "wscsvc"{
        Name        = "wscsvc"
        State       = "stopped"
        StartupType = "Disabled"
        }

        Write-Verbose "Service SensrSvc will be Disabled."
        Service "SensrSvc"{
        Name        = "SensrSvc"
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

        Write-Verbose "Service wcncsvc will be Disabled."
        Service "wcncsvc"{
        Name        = "wcncsvc"
        State       = "stopped"
        StartupType = "Disabled"
        }

        Write-Verbose "Service WMPNetworkSvc will be Disabled."
        Service "WMPNetworkSvc"{
        Name        = "WMPNetworkSvc"
        State       = "stopped"
        StartupType = "Disabled"
        }

        Write-Verbose "Service WlanSvc will be Disabled."
        Service "WlanSvc"{
        Name        = "WlanSvc"
        State       = "stopped"
        StartupType = "Disabled"
        }

        Write-Verbose "Service WwanSvc will be Disabled."
        Service "WwanSvc"{
        Name        = "WwanSvc"
        State       = "stopped"
        StartupType = "Disabled"
        }

        Write-Verbose "Service SysMain will be Disabled."
        Service "SysMain"{
        Name        = "SysMain"
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

        Write-Verbose "Service WSearch will be Disabled."
        Service "WSearch"{
        Name        = "WSearch"
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

        Write-Verbose "Appx package Microsoft.BingWeather_4.25.20211.0_neutral_~_8wekyb3d8bbwe will be removed."
        cAppxProvisionedPackage "Microsoft.BingWeather_4.25.20211.0_neutral_~_8wekyb3d8bbwe"
        {
        PackageName = "Microsoft.BingWeather_4.25.20211.0_neutral_~_8wekyb3d8bbwe"
        Ensure = "Absent"
        }

        Write-Verbose "Appx package Microsoft.SkypeApp_15.79.95.0_neutral_~_kzf8qxf38zg5c will be removed."
        cAppxProvisionedPackage "Microsoft.SkypeApp_15.79.95.0_neutral_~_kzf8qxf38zg5c"
        {
        PackageName = "Microsoft.SkypeApp_15.79.95.0_neutral_~_kzf8qxf38zg5c"
        Ensure = "Absent"
        }

        Write-Verbose "Appx package Microsoft.WindowsAlarms_2021.2101.28.0_neutral_~_8wekyb3d8bbwe will be removed."
        cAppxProvisionedPackage "Microsoft.WindowsAlarms_2021.2101.28.0_neutral_~_8wekyb3d8bbwe"
        {
        PackageName = "Microsoft.WindowsAlarms_2021.2101.28.0_neutral_~_8wekyb3d8bbwe"
        Ensure = "Absent"
        }

        Write-Verbose "Appx package Microsoft.WindowsCalculator_2020.2103.8.0_neutral_~_8wekyb3d8bbwe will be removed."
        cAppxProvisionedPackage "Microsoft.WindowsCalculator_2020.2103.8.0_neutral_~_8wekyb3d8bbwe"
        {
        PackageName = "Microsoft.WindowsCalculator_2020.2103.8.0_neutral_~_8wekyb3d8bbwe"
        Ensure = "Absent"
        }

        Write-Verbose "Appx package microsoft.windowscommunicationsapps_16005.14326.20544.0_neutral_~_8wekyb3d8bbwe will be removed."
        cAppxProvisionedPackage "microsoft.windowscommunicationsapps_16005.14326.20544.0_neutral_~_8wekyb3d8bbwe"
        {
        PackageName = "microsoft.windowscommunicationsapps_16005.14326.20544.0_neutral_~_8wekyb3d8bbwe"
        Ensure = "Absent"
        }

        Write-Verbose "Appx package Microsoft.WindowsSoundRecorder_2021.2103.28.0_neutral_~_8wekyb3d8bbwe will be removed."
        cAppxProvisionedPackage "Microsoft.WindowsSoundRecorder_2021.2103.28.0_neutral_~_8wekyb3d8bbwe"
        {
        PackageName = "Microsoft.WindowsSoundRecorder_2021.2103.28.0_neutral_~_8wekyb3d8bbwe"
        Ensure = "Absent"
        }

        Write-Verbose "Appx package Microsoft.ZuneMusic_2019.21102.11411.0_neutral_~_8wekyb3d8bbwe will be removed."
        cAppxProvisionedPackage "Microsoft.ZuneMusic_2019.21102.11411.0_neutral_~_8wekyb3d8bbwe"
        {
        PackageName = "Microsoft.ZuneMusic_2019.21102.11411.0_neutral_~_8wekyb3d8bbwe"
        Ensure = "Absent"
        }

        Write-Verbose "Appx package Microsoft.ZuneVideo_2019.21111.10511.0_neutral_~_8wekyb3d8bbwe will be removed."
        cAppxProvisionedPackage "Microsoft.ZuneVideo_2019.21111.10511.0_neutral_~_8wekyb3d8bbwe"
        {
        PackageName = "Microsoft.ZuneVideo_2019.21111.10511.0_neutral_~_8wekyb3d8bbwe"
        Ensure = "Absent"
        }

        Write-Verbose "Scheduled Task AnalyzeSystem will be Disabled."
        ScheduledTask "AnalyzeSystem"
        {
        TaskName            = "AnalyzeSystem"
        TaskPath            = "\Microsoft\Windows\Power Efficiency Diagnostics"
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

        Write-Verbose "Scheduled Task FamilySafetyMonitor will be Disabled."
        ScheduledTask "FamilySafetyMonitor"
        {
        TaskName            = "FamilySafetyMonitor"
        TaskPath            = "\Microsoft\Windows\Shell"
        Enable              = [bool]$false
        Ensure              = "Absent"
        }

        Write-Verbose "Scheduled Task File History (maintenance mode) will be Disabled."
        ScheduledTask "File History (maintenance mode)"
        {
        TaskName            = "File History (maintenance mode)"
        TaskPath            = "\Microsoft\Windows\FileHistory"
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

        Write-Verbose "Scheduled Task Microsoft Compatibility Appraiser will be Disabled."
        ScheduledTask "Microsoft Compatibility Appraiser"
        {
        TaskName            = "Microsoft Compatibility Appraiser"
        TaskPath            = "\Microsoft\Windows\Application Experience"
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

        Write-Verbose "Scheduled Task ProactiveScan will be Disabled."
        ScheduledTask "ProactiveScan"
        {
        TaskName            = "ProactiveScan"
        TaskPath            = "\Microsoft\Windows\CHKDSK"
        Enable              = [bool]$false
        Ensure              = "Absent"
        }

        Write-Verbose "Scheduled Task ProcessMemoryDiagnosticEvents will be Disabled."
        ScheduledTask "ProcessMemoryDiagnosticEvents"
        {
        TaskName            = "ProcessMemoryDiagnosticEvents"
        TaskPath            = "\Microsoft\Windows\MemoryDiagnostic"
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

        Write-Verbose "Scheduled Task RunFullMemoryDiagnostic will be Disabled."
        ScheduledTask "RunFullMemoryDiagnostic"
        {
        TaskName            = "RunFullMemoryDiagnostic"
        TaskPath            = "\Microsoft\Windows\MemoryDiagnostic"
        Enable              = [bool]$false
        Ensure              = "Absent"
        }

        Write-Verbose "Scheduled Task Scheduled will be Disabled."
        ScheduledTask "Scheduled"
        {
        TaskName            = "Scheduled"
        TaskPath            = "\Microsoft\Windows\Diagnosis"
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

        Write-Verbose "Scheduled Task SR will be Disabled."
        ScheduledTask "SR"
        {
        TaskName            = "SR"
        TaskPath            = "\Microsoft\Windows\SystemRestore"
        Enable              = [bool]$false
        Ensure              = "Absent"
        }

        Write-Verbose "Scheduled Task StartComponentCleanup will be Disabled."
        ScheduledTask "StartComponentCleanup"
        {
        TaskName            = "StartComponentCleanup"
        TaskPath            = "\Microsoft\Windows\Servicing"
        Enable              = [bool]$false
        Ensure              = "Absent"
        }

        Write-Verbose "Scheduled Task StartupAppTask will be Disabled."
        ScheduledTask "StartupAppTask"
        {
        TaskName            = "StartupAppTask"
        TaskPath            = "\Microsoft\Windows\Application Experience"
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

        Write-Verbose "Scheduled Task VerifyWinRE will be Disabled."
        ScheduledTask "VerifyWinRE"
        {
        TaskName            = "VerifyWinRE"
        TaskPath            = "\Microsoft\Windows\RecoveryEnvironment"
        Enable              = [bool]$false
        Ensure              = "Absent"
        }

        Write-Verbose "Scheduled Task Windows Defender Cache Maintenance will be Disabled."
        ScheduledTask "Windows Defender Cache Maintenance"
        {
        TaskName            = "Windows Defender Cache Maintenance"
        TaskPath            = "\Microsoft\Windows\Windows Defender"
        Enable              = [bool]$false
        Ensure              = "Absent"
        }

        Write-Verbose "Scheduled Task Windows Defender Cleanup will be Disabled."
        ScheduledTask "Windows Defender Cleanup"
        {
        TaskName            = "Windows Defender Cleanup"
        TaskPath            = "\Microsoft\Windows\Windows Defender"
        Enable              = [bool]$false
        Ensure              = "Absent"
        }

        Write-Verbose "Scheduled Task Windows Defender Scheduled Scan will be Disabled."
        ScheduledTask "Windows Defender Scheduled Scan"
        {
        TaskName            = "Windows Defender Scheduled Scan"
        TaskPath            = "\Microsoft\Windows\Windows Defender"
        Enable              = [bool]$false
        Ensure              = "Absent"
        }

        Write-Verbose "Scheduled Task Windows Defender Verification will be Disabled."
        ScheduledTask "Windows Defender Verification"
        {
        TaskName            = "Windows Defender Verification"
        TaskPath            = "\Microsoft\Windows\Windows Defender"
        Enable              = [bool]$false
        Ensure              = "Absent"
        }

        Write-Verbose "Scheduled Task WinSAT will be Disabled."
        ScheduledTask "WinSAT"
        {
        TaskName            = "WinSAT"
        TaskPath            = "\Microsoft\Windows\Maintenance"
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

citrix-optimizer-windows-8
