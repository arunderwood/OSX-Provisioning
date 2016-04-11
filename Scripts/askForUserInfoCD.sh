#!/bin/sh
# Joe Thurwood 17/09/2014
# Modified by arunderwood 4/6/2016
#
# The purpose of this script is to create a local user on the machine being imaged,
# using a user name and password that is specified by the tech during the imaging process.
#
# This script should be scheduled to run during a Deploy Studio Workflow.
# It asks the technician to enter a first name, a last name, and a password
# for the local user that will later be created on the machine being imaged.
#
# The information is recorded to RSCP variables and later commited to the disk
# of the imaged machine by the appendcustomvars.sh script so the information can
# later be referenced by scripts run after we exit the DeployStudio Runtime.
#
# This script requires cocoaDialog.app to be stored in the root of your DeployStudio shares Scripts directory.
#  It has only been tested with cocoaDialog 3.0.0-beta7
#

#
#
# Config
################################



	# Set cocoaDialog location
		CD=`dirname "$0"`/cocoaDialog.app/Contents/MacOS/cocoaDialog
		#CD=./cocoaDialog.app/Contents/MacOS/cocoaDialog  ##Use this path if your testing outside DS runtime
	

	## This option allows you to skip entering a password by pulling a default password from a local file.  Setting the same password every time makes it easier
	##    for the Helpdesk to deploy the machine to the new user.
	#
	# The password file should be created in a format that can be read by the "sources" command in bash
	#
	#
	
		PASS_FILE=`dirname "$0"`/default_user_pass.cfg


#############################################
# Asking the tech for username and password
#

	echo "RuntimeSetCustomProperty: RSCP_USER_ABORT=0"
	
	while true; do
  	
  		# Dialog to enter the $FIRSTNAME variable
  		fn=($($CD standard-inputbox --title "Firstname" --no-newline --float --icon "user/person" --informative-text "Enter the users FIRST NAME with proper capitalization."))
    	
  	
		  	if [ "$fn" == "1" ]; then
      				FIRSTNAME=${fn[1]}
				echo "Tech entered first name: $FIRSTNAME"

    				if [ -z "$FIRSTNAME" ]; then
				      	echo "You need to enter a firstname"
				      	continue

			    	fi
		    	elif [ "$fn" == "2" ]; then
			    	echo "Tech opted to cancel the First name step, skipping user creation."
			    	echo "RuntimeSetCustomProperty: RSCP_USER_ABORT=1"
			    	exit 0
		  	fi
  	
  	break
	done
	
	
	
	while true; do
  	
	  	# Dialog to enter the $LASTNAME variable
  		ln=($($CD standard-inputbox --title "Lastname" --no-newline --float --icon "user/person" --informative-text "Enter the users LAST NAME with proper capitalization."))
  	
  	
		  	if [ "$ln" == "1" ]; then	
  				LASTNAME=${ln[1]}
				echo "Tech entered the last name: $LASTNAME"
    	
			    	if [ -z "$LASTNAME" ]; then
				      	echo "You need to enter a lastname"
				      	continue
    				fi

		    	elif [ "$ln" == "2" ]; then
			    	echo "Tech opted to cancel the Last name step, skipping user creation."
			    	echo "RuntimeSetCustomProperty: RSCP_USER_ABORT=1"
			    	exit 0
		  	fi
  	
  	break
	done
	
	
	if [ -f $PASS_FILE ]; then
		echo "PASS_FILE '$PASS_FILE' Exists. Using preconfigured password."
	
		source $PASS_FILE
	
	else
		echo "$PASSFILE Does Not Exist, asking the tech to enter a password for the new user."
	
		while true; do
	
			# Dialog to enter the $USER_PASSWORD variable
			ln=($($CD standard-inputbox --title "Password" --no-newline --float --icon "user/person" --informative-text "Enter the users temporary password with proper capitalization."))
	
	
			if [ "$ln" == "1" ]; then
        			USER_PASSWORD=${ln[1]}
		        	echo "Tech entered the password: $USER_PASSWORD"
	
				if [ -z "$USER_PASSWORD" ]; then
		      			echo "You need to enter a password"
					continue
				fi
			elif [ "$ln" == "2" ]; then
    				echo "Tech opted to cancel the password step, but we cant proceed without a password. Try again"
    				continue
			fi
	
		break
		done
	
	fi
	
##################
# Using First and Last name vars, build a Firstname Lastname and a firstname.lastname
# These values are used for the user accounts full name and short name respectively.
#


	FULLNAME="$FIRSTNAME $LASTNAME"
	USERNAME=$(echo "$FIRSTNAME$LASTNAME" | tr '[:upper:]' '[:lower:]')


#################
#Commit the variables we need to Runtime Custom Properties so we can access them in other scripts
#
#
# Echo a KEY=value pair with the prefix RuntimeSetCustomProperty to make
# DeployStudio Runtime set or update a custom property for the current computer.
#
# Example:
#
# echo "RuntimeSetCustomProperty: MY_CUSTOM_KEY=DeployStudio Rocks!"

	echo "RuntimeSetCustomProperty: RSCP_USERFIRSTLAST=$USERNAME"
	echo "RuntimeSetCustomProperty: RSCP_USERFULLNAME=$FULLNAME"
	echo "RuntimeSetCustomProperty: RSCP_USERPASSWORD=$USER_PASSWORD"
