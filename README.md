# VirtualEnvWrapper for Windows Powershell

This is a mimic of the powerfull [virtualenvwrapper](https://bitbucket.org/virtualenvwrapper/) but for [Windows Powershell](https://bitbucket.org/virtualenvwrapper/). 

Unless the previous version of my estimated colleague [Guillermo Lòpez](https://bitbucket.org/guillermooo/virtualenvwrapper-powershell/overview) equivalent but obsolete it's compatible with Python 2+ and entierly based on a PowerShell script.

## Installation

Just use the `Install.ps1` script:

```powershell
./Install.ps1
```

and the script will create required path if needed and install the `profile.ps1` file directly to 
automaticly activate VirtualEnvWrapper when the shell is opened

###Manual Installation 
Put the file `VirtualEnvWrapper.psm1` into the directory `~\Documents\WindowsPowerShell\Modules`.
Edit or create the file `~\Documents\WindowsPowerShell\Profile.ps1` (see )
and add into the lines below :

```powershell
$MyDocuments = [Environment]::GetFolderPath("mydocuments")
Import-Module $MyDocuments\WindowsPowerShell\Modules\VirtualEnvWrapper.psm1
```

## Location

The virtual environments directory is set into your personnal directory : `~/Envs` 

Where `~` is your personnal directory.

If you want to set your environment. Just add and variable environment called :

`WORKON_HOME` (as in Unix/Linux system).


## Usage

The module add few commands in Powershell : 

* `lsvirtualenv` (alias: Get-VirtualEnvs) : List all Virtual environments
* `mkvirtualenv` (alias: New-VirtualEnv) : Ceate a new virtual environment
* `rmvirtualenv` (alias: Remove-VirtualEnv) : Remove an existing virtual environment
* `workon`: Activate an existing virtual environment
* `Get-VirtualEnvsVersion`: to display the current version.

### Create a virtual environment

To create a virtual environment just type:

    MkVirtualEnv -Name MyEnv -Python ThePythonDistDir

where `MyEnv` is your environment and `ThePythonDistDir` is where the `python.exe` live.  For example:

    MkVirtualEnv -Name MyProject -Python c:\Python36 

will create and virtual environment named `MyProject` located at `~\Envs` with the Python 3.6 distribution located at `C:\Python36` 

If the `-Python` option is not set, the python command set in your path is used by default.

Options are:

* `-Name` : The new environment name
* `-Packages` or `-i` : Install packages separated by a coma (Note: this differs from [original virtualenvwrapper](https://bitbucket.org/virtualenvwrapper/virtualenvwrapper/src/master/) )
* `-Associate` or `-a`: Still todo
* `-Requirement` or `-r`: The requirement file to load. 

If both options Packages and Requirement are set, the script will install first the packages then the requirements as in original Bash script.


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

### Development

A script `InstallDev.ps1` exists to simplify the development. Invoke it with:

    $ .\InstallDev.ps1 

will unload `VirtualEnvWrapper.ps1` from memory and reload it.
