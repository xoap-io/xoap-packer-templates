<#
.SYNOPSIS
    Deploys a vSphere VM using OpenTofu from a Packer template, with variables set in PowerShell.

.DESCRIPTION
    Downloads OpenTofu if missing, sets deployment variables, writes a .tfvars file, initializes and applies the stack.
#>

# --- User variables ---
$vsphereServer   = "vsphere.example.com"
$vsphereUser     = "administrator@vsphere.local"
$vspherePassword = "ReplaceWithASecurePassword123!"
$datacenter      = "Datacenter"
$cluster         = "Cluster"
$resourcePool    = "Resources"
$datastore       = "Datastore"
$template        = "packer-template-name" # Replace with your Packer template name
$vmName          = "packer-vsphere-vm"
$network         = "VM Network"
$folder          = "VMs"
$cpu             = 2
$memory          = 4096

# --- Download OpenTofu if missing ---
$tofuExe = "$env:USERPROFILE\opentofu.exe"
if (-not (Test-Path $tofuExe)) {
    Write-Host "Downloading OpenTofu..."
    $url = "https://github.com/opentofu/opentofu/releases/latest/download/opentofu_windows_amd64.zip"
    $zip = "$env:TEMP\opentofu.zip"
    Invoke-WebRequest -Uri $url -OutFile $zip
    Expand-Archive -Path $zip -DestinationPath $env:USERPROFILE -Force
    Remove-Item $zip
    Write-Host "OpenTofu downloaded to $tofuExe"
}

# --- Write variables to .tfvars file ---
$tfvars = @"
vsphere_server   = "$vsphereServer"
vsphere_user     = "$vsphereUser"
vsphere_password = "$vspherePassword"
datacenter       = "$datacenter"
cluster          = "$cluster"
resource_pool    = "$resourcePool"
datastore        = "$datastore"
template         = "$template"
vm_name          = "$vmName"
network          = "$network"
folder           = "$folder"
cpu              = $cpu
memory           = $memory
"@
Set-Content -Path ".\variables.tfvars" -Value $tfvars

# --- Run OpenTofu ---
$env:PATH += ";$env:USERPROFILE"
Write-Host "Initializing OpenTofu stack..."
& $tofuExe init

Write-Host "Planning OpenTofu stack..."
& $tofuExe plan -var-file="variables.tfvars"

Write-Host "Applying OpenTofu stack..."
& $tofuExe apply -auto-approve -var-file="variables.tfvars"
