#!/bin/sh

# Set cocoaDialog location
CD=`dirname "$0"`/cocoaDialog.app/Contents/MacOS/cocoaDialog


echo “Curly RSCP_USERFULLNAME is ${RSCP_USERFULLNAME}”
echo “Curly RSCP_USERFIRSTLAST is ${RSCP_USERFIRSTLAST}”

echo .

echo “RSCP_USERFULLNAME is $RSCP_USERFULLNAME”
echo “RSCP_USERFIRSTLAST is $RSCP_USERFIRSTLAST”

echo .

echo “Curly USERFULLNAME is $USERFULLNAME”
echo “Curly USERFIRSTLAST is $USERFIRSTLAST”

echo .

echo “The current workflow is $DS_CURRENT_WORKFLOW_TITLE”

# Dialog to enter the $FIRSTNAME variable
  fn=($($CD standard-inputbox --title "Firstname" --no-newline --float --icon "user/person" --informative-text "Enter the users FIRST NAME with proper capitalization."))
