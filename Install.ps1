#
# VirtualEnvWrapper for Power shell
#
# Installation script
#

$MyDocuments = [Environment]::GetFolderPath("MyDocuments")
$PowerShellPath = Join-Path $MyDocuments WindowsPowerShell
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
    Write-Host "Creaate directory : $InstallationPath"
    New-Item -ItemType Directory -Force -Path $InstallationPath
}

Copy-Item VirtualEnvWrapper.psm1 $InstallationPath\VirtualEnvWrapper.psm1

# If Powershell profile doesn't exist, add it with necessary contents
# Otherwise append contents to existing profile
if (!(Test-Path $profile))
{
    $key = Ask-User "The powershell profile is missing. Do you want to create it?"
    if ($key -eq "y")
    {
        Copy-Item Profile.ps1 $profile
    }
}
else
{
    $From = Get-Content -Path Profile.ps1

    if(!(Select-String -SimpleMatch "VirtualEnvWrapper.psm1" -Path $profile))
    {
        Add-Content -Path $profile -Value "`r`n"
        Add-Content -Path $profile -Value $From
    }
}

Write-Host "Installation done. Close this PowerShell and re-open it to activate VirtualEnvWrapper"
Write-Host