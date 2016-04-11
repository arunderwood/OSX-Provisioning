#!/bin/sh
#
# This script reads the username and password for the recently created local user.
# It then sets the username to be the autoLoginUser and use the set_kcpassword.py
# script to generate the obfuscated password the OS will be looking for and writes
# it to /etc/kcpassword.
#

######################################################
##Config
#
# 

## Source the config file that contains our username and password for our local user

	source /Library/tmp/DStempinstallers/local_users.cfg

## Path to set_kcpassword.py

	SET_KCPASSWORD="/Library/tmp/DStempinstallers/set_kcpassword.py"

######################################################
	
	defaults write '/Library/Preferences/com.apple.loginwindow.plist' autoLoginUser $USERNAME
	
	echo "AutoLogin enabled for $USERNAME"
	
	#defaults write /Library/Preferences/com.apple.loginwindow StartupDelay -int 35
	
	#echo "LoginWindow Delay set to 35 secs"
	
	python $SET_KCPASSWORD "$USER_PASSWORD"
	
	#cp -v /Library/tmp/DStempinstallers/kcpassword /etc/kcpassword
	#chmod 600 /etc/kcpassword
	#chown root /etc/kcpassword
	
	exit 0
	
