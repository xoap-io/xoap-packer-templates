<#
.SYNOPSIS
    Deploys a Google Cloud VM using OpenTofu from a Packer image, with variables set in PowerShell.

.DESCRIPTION
    Downloads OpenTofu if missing, sets deployment variables, writes a .tfvars file, initializes and applies the stack.
#>

# --- User variables ---
$instanceName   = "packer-gcp-vm"
$project        = "your-gcp-project-id"
$region         = "europe-west1"
$zone           = "europe-west1-b"
$imageName      = "packer-image-name"      # Replace with your Packer image name
$imageFamily    = "packer-image-family"    # Optional: set if you use image family
$machineType    = "e2-medium"
$network        = "default"
$subnetwork     = ""                       # Optional: set if you want a specific subnetwork

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
instance_name = "$instanceName"
project       = "$project"
region        = "$region"
zone          = "$zone"
image_name    = "$imageName"
image_family  = "$imageFamily"
machine_type  = "$machineType"
network       = "$network"
subnetwork    = "$subnetwork"
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
