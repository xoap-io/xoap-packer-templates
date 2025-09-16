<#
.SYNOPSIS
    Deploys an Azure VM using OpenTofu from a Packer image, with variables set in PowerShell.

.DESCRIPTION
    Downloads OpenTofu if missing, sets deployment variables, writes a .tfvars file, initializes and applies the stack.
#>

# --- User variables ---
$vmName         = "packer-vm"
$resourceGroup  = "packer-vm-rg"
$location       = "westeurope"
$imageId        = "/subscriptions/<subscription_id>/resourceGroups/<packer_image_rg>/providers/Microsoft.Compute/images/<packer_image_name>"
$adminUsername  = "azureuser"
$adminPassword  = "ReplaceWithASecurePassword123!"

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
vm_name        = "$vmName"
resource_group = "$resourceGroup"
location       = "$location"
image_id       = "$imageId"
admin_username = "$adminUsername"
admin_password = "$adminPassword"
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
