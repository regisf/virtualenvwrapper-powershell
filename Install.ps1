#
# VirtualEnvWrapper for Power shell
#
# Installation script
#

$PowerShellProfile = $PROFILE.CurrentUserAllHosts
$PowerShellPath = Split-Path $PowerShellProfile
$InstallationPath = Join-Path $PowerShellPath Modules

function Ask-User($Message)
{
    Do 
    {
        $Key = (Read-Host "$Message [Y/n]").ToLower()
    } While ($Key -ne "y" -And $Key -ne "n")

    return $Key
}

Write-Host
$key = Ask-User "Do you want to install VirtualEnvWrapper for PowerShell"
if ($key -eq "n") 
{
    Exit
}

# Test powershell directories in ~\Documents. If don't exists create it
if (!(Test-Path $InstallationPath)) 
{
    Write-Host "Create directory : $InstallationPath"
    New-Item -ItemType Directory -Force -Path $InstallationPath
}

Copy-Item VirtualEnvWrapper.psm1 $InstallationPath\VirtualEnvWrapper.psm1

# If Powershell profile doesn't exist, add it with necessary contents
# Otherwise append contents to existing profile
if (!(Test-Path $PowerShellProfile))
{
    $key = Ask-User "The powershell profile is missing. Do you want to create it?"
    if ($key -eq "y")
    {
        Copy-Item Profile.ps1 $PowerShellProfile
    }
}
else
{
    $From = Get-Content -Path Profile.ps1

    if(!(Select-String -SimpleMatch "VirtualEnvWrapper.psm1" -Path $PowerShellProfile))
    {
        Add-Content -Path $PowerShellProfile -Value "`r`n"
        Add-Content -Path $PowerShellProfile -Value $From
    }
}

Write-Host "Installation done. Close this PowerShell and re-open it to activate VirtualEnvWrapper"
Write-Host