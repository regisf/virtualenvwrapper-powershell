# Changelog for VirtualEnvWrapper Powershell

## 2020-01-28 (v0.2.0)
	* Implement `mktmpenv` as an alias of `New-TemporaryVirtualEnv`
	* Merge [rbierbasz](https://github.com/rbierbasz) pull request

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
