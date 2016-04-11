#!/bin/sh
# Joe Thurwood 17/09/2014
# Modified by arunderwood 4/6/2016
#
# Creates a new local user based on values in the local_users.cfg file
# Information for the local_users.cfg is gathered by the askForUserInfoCD.sh
# script and written to the disk by the appendcustomvars.sh script.
#

########################################################
# Config
#
	##Specifies the script name
		SCRIPT_NAME=`basename "${0}"`

	##Location of the local_users.cfg file
		source /Library/tmp/DStempinstallers/local_users.cfg

	##These are the secondary groups we want the user to be a part of as an admin user
	SECONDARY_GROUPS="admin _lpadmin _appserveradm _appserverusr" 


#######################################################
#
#
	echo "${SCRIPT_NAME} ("`date`")"
	
#######################################################
# If USER_ABORT is set to 1, the tech canceled the local user creation process.  Exit now without creating a user.	
#

	if [ $USER_ABORT == "1" ]; then
		echo "User creation is being skipped."
		exit 0
	fi
	
	
	echo “USERNAME is $USERNAME”
	echo “FULLNAME is $FULLNAME”
	echo "USER_PASSWORD is $USER_PASSWORD"
	

#######################################################
# This sorts the list of userIDs to find the highest one
#

	LastID=`dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1`
	
########################################################
# This adds one to the highest userID.  This will be the UID for the new user
#
	NextID=$((LastID + 1))


########################################################
# Arguably the most important part of the script.
# It actually creates the user account
#
	dscl . create /Users/"$USERNAME"
	dscl . create /Users/"$USERNAME" RealName "$FULLNAME"
	dscl . passwd /Users/"$USERNAME" "$USER_PASSWORD"
	dscl . create /Users/"$USERNAME" UniqueID "$NextID"
	dscl . create /Users/"$USERNAME" PrimaryGroupID 20
	dscl . create /Users/"$USERNAME" UserShell /bin/bash
	dscl . create /Users/"$USERNAME" NFSHomeDirectory /Users/"$USERNAME"

########################################################
# If the custom logo was copied over succesfully, set it as the user icon
# If we can't find the custom logo, use the Gingerbread man
#	

	if [ -e "/Library/User Pictures/Wlogo.png" ]
		then
    			dscl . -create /Users/"$USERNAME" Picture "/Library/User Pictures/Wlogo.png"
		else
			dscl . -create /Users/"$USERNAME" Picture "/Library/User Pictures/Fun/Gingerbread Man.tif"    
	fi
	

########################################################
# Add user to any specified groups
#

	echo "Adding user to specified groups..."
	
	for GROUP in $SECONDARY_GROUPS ; do
  	dseditgroup -o edit -t user -a "$USERNAME" "$GROUP"
	done
	

########################################################
# Create the home directory
# The extra piping filters out garbage errors thrown by createhomedir
#

	echo "Creating home directory..."
	createhomedir -c -u "$USERNAME" 2>&1 | grep -v CFPasteboardRef | grep -v shell-init
