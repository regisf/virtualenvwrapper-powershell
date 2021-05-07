# Changelog for VirtualEnvWrapper Powershell

## 2021-05-07 (v.0.1.4)
    * Fix various compatibility issues with PowerShell 7 (thanks to @mmorys and @dbellandi)

## 2020-11-26 (v0.1.3)
	* Fix issue #21 due to working branch accidentaly merged on master

## 2020-11-17 (v0.1.2)
	* Fix bug on Get-VirtualEnvs for user with space in name
	* Fix uncomplete environment

## 2019-11-10 (v0.1.1)
	* Partially merge Swiffer PR
	* Start tagging
	
## 2015-05-13
	* Fix bug #1 (thanks to franciscosucre)
	* Add installation script
	* Improve ReadMe
	* Add changelog file
	* Fix Workon bug which deactivate a python env even if the new one didn't exists
	* Change Python virtual environment path with system variable
	* Add version asking
	* Avoid virtual envs that begins with '-'
