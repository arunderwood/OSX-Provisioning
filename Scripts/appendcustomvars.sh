#!/bin/sh
#
# In it's current state, Deploy Studio custom variables are only accessible during the Runtime portion of the imaging process.
# Because we usually need access to some of that info during the ds_finalize steps and beyond, it's helpful to be able to
# write some of those variables to a config file on the imaged machines disk so it can be read back later.
#
# You will probably want to schedule this script as the last step in your Workflow, but before the machine reboots.
# You will want to schedule it after the disk has been partitioned and the image as been restored.
# Don't schedule it as postponed.  The script wont be able to read the RSCP variables.
#
# To write a Runtime Custom Variable from a script:
#
# 	Echo a KEY=value pair with the prefix RuntimeSetCustomProperty to make
# 	DeployStudio Runtime set or update a custom property for the current computer.
#
# 	Example:
#
# 		echo "RuntimeSetCustomProperty: MY_CUSTOM_KEY=DeployStudio Rocks!"
#
#
# To read the variables back into future scripts during the ds-finalize step (or anytime after that)
# For more info, look up the man page for the 'source' command.
#
#	source [PATH TO CONFIG FILE]
#
#	Example:
#
#		source /Library/tmp/DStempinstallers/local_users.cfg
#
#

##############################################
# Config
#

##This is where we should write the config file

	CONFIG_PATH="/Volumes/$DS_LAST_SELECTED_TARGET/Library/tmp/DStempinstallers/local_users.cfg"


##############################################

	echo "Writing local username information to our config file"
	
## Initialize the empty config file

	touch "/Volumes/$DS_LAST_SELECTED_TARGET/Library/tmp/DStempinstallers/local_users.cfg"

############################################### 
# Write out the Runtime variables to the config file.  Make sure to encapsulate them in escaped double quotes so source can read them back later.
#

	echo "USERNAME=\"$RSCP_USERFIRSTLAST\"" >> $CONFIG_PATH
	echo "FULLNAME=\"$RSCP_USERFULLNAME\"" >> $CONFIG_PATH
	echo "USER_PASSWORD=\"$RSCP_USERPASSWORD\"" >> $CONFIG_PATH
	echo "USER_ABORT=\"$RSCP_USER_ABORT\"" >> $CONFIG_PATH
	
###############################################
# Read back the config file to the tech and the log
#	
	echo "Config file:"
	cat $CONFIG_PATH
	
