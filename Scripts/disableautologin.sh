#!/bin/sh
#
# OS X does not have a clean way to schedule a machine to automatically login once.  This script works around that by waiting for the machine to boot
#  then disabling autologin.
#
# This script can be run in two ways.  If scheduled in a DeployStudiowith Workflow as a postponed task with the argument "install", it will 
#  create a new Launch Daemon.
#
# This Daemon will run on the next boot of the machine, which should be the first boot after the ds_finalize step completes, the Launch Daemon will call
#  this script with the argument "launchd", causing the script to wait a period of time giving the machine time to autoLogin, then the script will unset 
#  the autoLoginUser as well as cleaning up the autologin password.  The script will then delete the launch daemon as well as itself.
#
#

########################################################################
# Config
#
#

	LAUNCHDPATH=/Library/LaunchDaemons
	
	

########################################################################
# Execute this block if the script is called with the "install" argument
#
#

if [ "$1" == "install" ]; then

	echo "Installing the launchd daemon."

read -d '' DALlaunchd <<"EOF"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
	<dict>
		<key>Label</key>
		<string>com.workiva.disableautologin</string>
		<key>ProgramArguments</key>
			<array>
			<string>/Library/tmp/DStempinstallers/disableautologin.sh</string>
			<string>launchd</string>
			</array>
		<key>RunAtLoad</key>
			<true/>
		<key>Disabled</key>
			<false/>
		<key>StandardErrorPath</key>
			<string>/var/log/com.workiva.disableautologin_err.log</string>
		<key>StandardOutPath</key>
			<string>/var/log/com.workiva.disableautologin.log</string>
	</dict>
</plist>
EOF

	echo "${DALlaunchd}" > $LAUNCHDPATH/com.workiva.disableautologin.plist
	
	echo "The launch daemon has been written to $LAUNCHDPATH."
	
	echo "Making a copy of this script and sending it to /Library/tmp/DStempinstallers/disableautologin.sh"
		cp "$0" /Library/tmp/DStempinstallers/disableautologin.sh
		chmod +x /Library/tmp/DStempinstallers/disableautologin.sh
	
	exit 0
	


############################################
# Execute this next block if the script is called with the argument "launchd".  This should only happen when called by launchd
# 
#
	
	elif [ "$1" == "launchd" ]; then
	
	
		echo "Launchd has called $0"

	# Waiting 60 seconds should allow the machine to login before we disable autologin
		echo "Waiting 60 seconds..." 
			sleep 60
	
			/usr/libexec/PlistBuddy -c "Delete :autoLoginUser" /Library/Preferences/com.apple.loginwindow.plist
	
echo newline

/usr/libexec/PlistBuddy -c "print" /Library/Preferences/com.apple.loginwindow.plist

echo endline

		echo "Deleting the kcpassword"
			rm -f /etc/kcpassword
	
		echo "Deleting $LAUNCHDPATH/com.workiva.disableautologin"
			rm -f "$LAUNCHDPATH/com.workiva.disableautologin.plist"
	
		echo "Deleting $0"
			rm -f "$0"
	
	#
	# End of launchd block
##########################################################
# This block runs if no argument is specified.
#

	else
	
		echo "This script needs an argument to run. If you are trying to install the script, run it with the \"install\" argument."
		echo "If the script is installed and being called by launchd, yet you are still seeing this error, something is wrong."
	
	fi
	
