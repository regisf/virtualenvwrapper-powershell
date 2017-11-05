#
# Python virtual env manager heavely inspired by VirtualEnvWrapper
# (c) Régis FLORET 2017 and later
# 

#
# Set the default path and create the directory if don't exist
#
$virtualenvwrapper_home = "$Env:USERPROFILE\Envs"
if ((Test-Path $virtualenvwrapper_home) -eq $false) {
    mkdir $virtualenvwrapper_home
}

#
# Get the absolute path for the environment
#
function Get-FullPyEnvPath($pypath) {
    return ("{0}\{1}" -f $virtualenvwrapper_home, $pypath)
}

# 
# Display a formated error message
#
function Write-FormatedError($err) {
    Write-Host ""
    Write-Host "  ERROR: $err" -ForegroundColor Red
    Write-Host ""
}

#
# Display a formated success messge
#
function Write-FormatedSuccess($err) {
    Write-Host ""
    Write-Host "  SUCCESS: $err" -ForegroundColor Green
    Write-Host ""
}

function Get-PythonVersion($Python) {
    if (!$Python) {
        $python_exe = "python.exe"
    } else {
        if ((Test-Path $Python) -ne $true) {
            Write-FormatedError "$Python was not found"
            return $false
        }
        $python_exe = Join-Path $Python "python.exe"

        if ((Test-Path $python_exe) -ne $true) {
            Write-FormatedError "Unable to find the python executable into the given path: $Python"
            return $false
        }
    }

    $python_version = Invoke-Expression "$python_exe --version 2>&1"
    if (!$Python -and !$python_version) {
        Write-Host "I don't find any Python version into your path" -ForegroundColor Red
        return $false
    }

    $is_version_2 = ($python_version -match "^Python\s2") -or ($python_version -match "^Python\s3.3")
    $is_version_3 = $python_version -match "^Python\s3" -and !$is_version_2
    
    if (!$is_version_2 -and !$is_version_3) {
        Write-FormatedError "Unknown Python Version expected Python 2 or Python 3 got $python_version"
        return $false
    }

    return $(if ($is_version_2) {"2"} else {"3"})
}

#
# Common command to create the Python Virtual Environement. 
# $Command contains either the Py2 or Py3 command
#
function Invoke-CreatePyEnv($Command, $Name) {
    $NewEnv = Join-Path $virtualenvwrapper_home $Name
    Write-Host "Creating virtual env... "
    
    Invoke-Expression "$Command $NewEnv"
    
    $VEnvScritpsPath = Join-Path $NewEnv "Scripts"
    $ActivatepPath = Join-Path $VEnvScritpsPath "activate.ps1"
    . $ActivatepPath

    Write-FormatedSuccess "$Name virtual environment was created and your're in."
}

#
# Create Python Environment using the VirtualEnv.exe command
#
function New-Python2Env($Python, $Name) {
    $Command = (Join-Path (Join-Path $Python "Scripts") "virtualenv.exe")
    if ((Test-Path $Command) -eq $false) {
        Write-FormatedError "You must install virtualenv program to create the Python virtual environment '$Name'"
        return 
    }

    Invoke-CreatePyEnv $Command $Name
}
    
# 
# Create Python Environment using the venv module
# 
function New-Python3Env($Python, $Name) {
    if (!$Python) {
        $PythonExe = Find-Python
    } else {
        $PythonExe = Join-Path $Python "python.exe"
    }

    $Command = "$PythonExe -m venv"

    Invoke-CreatePyEnv $Command $Name
}

#
# Find python.exe in the path
#
function Find-Python {
    return Get-Command "python.exe" | Select-Object -ExpandProperty Source
}

#
# Create the Python Environment regardless the Python version
#
function New-PythonEnv($Version, $Python, $Name) {
    if ($Version -eq "2") {
        New-Python2Env -Python $Python -Name $Name
    } elseif ($Version -eq "3") {
        New-Python3Env -Python $Python -Name $Name
    } else {
        Write-FormatedError "This is the debug voice. You failed!"
    }
}

# 
# Test if there's currently a python virtual env
#
function Get-IsInPythonVenv($Name) {
    if ($Env:VIRTUAL_ENV) {
        if ($Name) {
            if (([string]$Env:VIRTUAL_ENV).EndsWith($Name)) {
                return $true
            }

            return $false;
        }

        return $true
    }

    return $false
}

# Now, work on a env
function workon {
    Param(
        [string] $Name
    )

    if (Get-IsInPythonVenv -eq $true) {
        Deactivate
    }

    if (!$Name) {
        Write-FormatedError "No python venv to work on. Did you forget the -Name option?"
        return
    }

    $new_pyenv = Get-FullPyEnvPath $Name
    if ((Test-Path $new_pyenv) -eq $false) {
        Write-FormatedError "The Python environment '$Name' don't exists. You may want to create it with 'MkVirtualEnv $Name'"
        return
    }

    $activate_path = "$new_pyenv\Scripts\Activate.ps1"
    if ((Test-path $activate_path) -eq $false) {
        Write-FormatedError "Enable to find the activation script. You Python environment $Name seems compromized"
        return
    }
    
    . $activate_path
}

function mkvirtualenv {
    Param(
        [string]$Name, 
        [string]$Python
    )
    
    if (!$Name) {
        Write-FormatedError "You must at least give me a PyEnv name"
        return
    }

    $which_python = Ensure-Python $Python
    if (!$which_python) {
       return
    }
    
    New-PythonEnv -Version $which_python -Python $Python -Name $Name
}

function New-VirtualEnv {
    Param(
        [string]$Name, 
        [string]$Python
    )

    mkvirtualenv -Name $Name -Python $python   
}

function lsvirtualenv {
    $children = Get-ChildItem $virtualenvwrapper_home
    Write-Host
    Write-Host "`tPython Virtual Environments available"
    Write-Host
    Write-host ("`t{0,-30}{1,-15}" -f "Name", "Python version")
    Write-host ("`t{0,-30}{1,-15}" -f "====", "==============")
    Write-Host

    if ($children.Length) {
        for($i = 0; $i -lt $children.Length; $i++) {
            $child = $children[$i]
            $PythonVersion = (((Invoke-Expression ("$virtualenvwrapper_home\{0}\Scripts\Python.exe --version 2>&1" -f $children[$i])) -replace "`r|`n","") -Split " ")[1]
            Write-host ("`t{0,-30}{1,-15}" -f $children[$i],$PythonVersion)
        }
    } else {
        Write-Host "`tNo Python Environments"
    }
    Write-Host
}

#
# Remove a virtual environment.
#
function rmvirtualenv {
    Param(
        [string]$Name
    )
    
    if ((Get-IsInPythonVenv $Name) -eq $true) {
        Write-FormatedError "You want to destroy the Virtual Env you are in. Please type 'deactivate' before to dispose the environment before"
        return
    }

    if (!$Name) {
        Write-FormatedError "You must fill a environmennt name"
        return
    }

    $full_path = Get-FullPyEnvPath $Name
    if ((Test-Path $full_path) -eq $true) {
        Remove-Item -Path $full_path -Recurse 
        Write-FormatedSuccess "$Name was deleted permantly"
    } else {
        Write-FormatedError "$Name not found"
    }
}

#
# Powershell alias for naming convention
#
Alias Get-VirtualEnvs lsvirtualenv 
Alias Remove-VirtualEnv rmvirtualenv
Alias New-VirtualEnv mkvirtualenv
