# VirtualEnvWrapper for Windows Powershell

This is a mimic of the powerfull [virtualenvwrapper](https://bitbucket.org/virtualenvwrapper/) but for [Windows Powershell](https://bitbucket.org/virtualenvwrapper/). 

Unless the previous version of my estimated colleague [Guillermo Lòpez](https://bitbucket.org/guillermooo/virtualenvwrapper-powershell/overview) equivalent but obsolete it's compatible with Python 2+ and entierly based on a PowerShell script.

## Installation

For now, there's not automatic installation. Put the file `VirtualEnvWrapper.psm1`
into the directory `~\Documents\WindowsPowerShell\Modules`.
Edit or create the file `~\Documents\WindowsPowerShell\WindowsPowerShell_profile.ps1`
and add into the lines below :

```powershell
$MyDocuments = [Environment]::GetFolderPath("mydocuments")
Import-Module $MyDocuments\WindowsPowerShell\Modules\VirtualEnvWrapper.psm1
```

## Location

The virtual environments directory is set into your personnal directory : `~/Envs` 

Where `~` is your personnal directory.

## Usage

The module add few commands in Powershell : 

* `lsvirtualenv` (alias: Get-VirtualEnvs) : List all Virtual environments
* `mkvirtualenv` (alias: New-VirtualEnv) : Ceate a new virtual environment
* `rmvirtualenv` (alias: Remove-VirtualEnv) : Remove an existing virtual environment
* `Workon`: Activate an existing virtual environment

### Create a virtual environment

To create a virtual environment just type:

    MkVirtualEnv -Name MyEnv -Python ThePythonDistDir

where `MyEnv` is your environment and `ThePythonDistDir` is where the `python.exe` live.  For example:

    MkVirtualEnv -Name MyProject -Python c:\Python36 

will create and virtual environment named `MyProject` located at `~\Envs` with the Python 3.6 distribution located at `C:\Python36` 

If the `-Python` option is not set, the python command set in your path is used by default.

### List virtual environments

Type

    LsVirtualEnv

in a Powershelll to display the entiere list with the Python version.

For Example:

```
Python Virtual Environments available

Name                          Python version
====                          ==============
TheProjectIHave               3.6.3
```

### Activate a virtual environment

Type

    workon TheEnvironment

in a console. The PS command line starts now with:

    (TheEnvironment) C:\Somewhere>

to show you what is the default 

To ensure that the Python environment is the good one type:

    Get-Command python

The path should be:

    ~\Envs\TheEnvironment\Scripts\python.exe


### Leave from a virtual environment

Just type `deactivate` as usual (Python default).

## Todo

* Activate the autocompletion
* Set the virtualenvwrapper options into system environment variables (see the main project)
