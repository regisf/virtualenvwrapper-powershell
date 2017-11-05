#
# This is a the few lines you have to add into the file:
# c:\Users\YOUR_PROFILE\Documents\WindowsPowerShell\WindowsPowerShell_Profile.ps1
#
$MyDocuments = [environment]::getfolderpath("mydocuments")
Import-Module $MyDocuments\WindowsPowerShell\Modules\VirtualEnvWrapper.psm1
