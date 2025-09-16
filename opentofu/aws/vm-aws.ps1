<#
.SYNOPSIS
    Deploys an AWS EC2 instance using OpenTofu from a Packer AMI, with variables set in PowerShell.

.DESCRIPTION
    Downloads OpenTofu if missing, sets deployment variables, writes a .tfvars file, initializes and applies the stack.
#>

# --- User variables ---
$instanceName   = "packer-aws-vm"
$region         = "eu-west-1"
$amiId          = "ami-xxxxxxxxxxxxxxxxx" # Replace with your Packer AMI ID
$instanceType   = "t3.micro"
$keyName        = "your-keypair-name"
$subnetId       = "subnet-xxxxxxxx"      # Optional: set if you want a specific subnet
$securityGroup  = "sg-xxxxxxxx"          # Optional: set if you want a specific security group

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
instance_name   = "$instanceName"
region          = "$region"
ami_id          = "$amiId"
instance_type   = "$instanceType"
key_name        = "$keyName"
subnet_id       = "$subnetId"
security_group  = "$securityGroup"
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
