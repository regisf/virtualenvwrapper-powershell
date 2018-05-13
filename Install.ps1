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

if (!(Test-Path (Join-Path $PowerShellPath Profile.ps1)))
{
    $key = Ask-User "The powershell profile is missing. Do you want to create it?"
    if ($key -eq "y")
    {
        Copy-Item Profile.ps1 $PowerShellPath\Profile.ps1
    }
}

Write-Host "Installation done. Close this PowerShell and re-open it to activate VirtualEnvWrapper"
Write-Host