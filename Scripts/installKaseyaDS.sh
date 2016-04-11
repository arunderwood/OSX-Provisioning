#!/bin/sh

echo "Unzipping the Kaseya installer..."
unzip "/Library/tmp/DStempinstallers/KcsSetup.zip" -d "/Library/tmp/DStempinstallers/" > /dev/null 2>&1

cd "/Library/tmp/DStempinstallers/Agent"

chmod 755 "KcsSetup.app/Contents/MacOS/KcsSetup"

echo "Installing Kaseya..."
"/Library/tmp/DStempinstallers/Agent/KcsSetup.app/Contents/MacOS/KcsSetup" -s > /dev/null 2>&1
