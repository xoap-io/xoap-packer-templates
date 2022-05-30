boot_command      = [
  "<enter>"
  ]
boot_wait         = "5s"
check_registry    = true
communicator      = "winrm"
compression_level = "9"
cpus              = 4
debug_mode        = 1
disk_adapter_type = "nvme"
disk_size         = 61440
disk_type_id      = "1"
elevated_password = ""
elevated_user     = ""
execution_policy  = "unrestricted"
floppy_files = [
  "./autounattend.xml",
  "../../../../scripts/disable-screensaver.ps1",
  "../../../../scripts/configure-winrm.ps1",
  "../../../../scripts/unattend.xml",
  "../../../../scripts/run-sysprep.ps1",
  "../../../../scripts/cleanup.ps1"
]
floppy_dirs = []
filters = [
  "exclude:$_.Title -like '*Preview*'",
  "exclude:$_.Title -like '*Feature update*'",
  "include:$true",
  ]
format               = "vmx"
guest_os_type        = "windows9srv-64"
headless             = "false"
iso_checksum         = "C9F06BE66D02D54B66F2473476079BA2D30117F458FE9A5ED905BB367F1195D1"
iso_url              = "../../../../iso/SW_DVD9_Win_Server_STD_CORE_2004_64Bit_English_SAC_DC_STD_MLF_-2_X22-29785.ISO"
keep_input_artifact  = true
max_retries          = 0
memory               = 4096
network_adapter_type = ""
output_directory     = "./output/w2004-std-core-en"
ovftool_options      = []
pause_before         = "10s"
restart_command      = ""
restart_timeout      = "5m"
search_criteria      = "IsInstalled=0"
skip_clean           = false
skip_compaction      = false
shutdown_command     = "powershell.exe -noexit -file a:/run-sysprep.ps1"
shutdown_timeout     = "1h"
start_retry_timeout  = "5m"
timeout              = "1h"
tools_upload_flavor  = ""
tools_upload_path    = ""
tools_source_path    = ""
update_limit         = 100
valid_exit_codes     = [
  "0",
  "4294967295"
  ]
vagrant_output_directory       = "./output/vagrant"
vagrant_version                = "0.0.1"
version                        = 19
vm_name                        = "w2004-std-core-en"
vmx_remove_ethernet_interfaces = true
vnc_port_min                   = 5980
vnc_port_max                   = 5990
winrm_insecure                 = true
winrm_password                 = "Password01"
winrm_port                     = "5985"
winrm_timeout                  = "2h"
winrm_use_ntlm                 = false
winrm_use_ssl                  = false
winrm_username                 = "xoap-admin"
