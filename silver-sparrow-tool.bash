#!/bin/bash
# datto RMM :: silver sparrow detection/inoculation tool :: build 8/seagull 21/02/22
# built from research by red canary team https://redcanary.com/blog/clipping-silver-sparrows-wings/
# Fedora-License-Identifier: BSD
# SPDX-License-Identifier: BSD-2-Clause
# SHARED for the greater good of the MSP community :: please preserve this comment block

function testFiles {
	if [[ -f "$1" ]]
	then
		((varMatches++))
		echo "- ALERT: File matching known records ($2) has been found."
		echo "  Location: $1"
		echo '  Results will be written to log file.'
		echo '- ALERT: File indicative of a Silver Sparrow infection was located.' >> $PWD\detection.txt
		echo "       Location:   $1" >> $PWD\detection.txt
		echo "       SS Version: $2" >> $PWD\detection.txt
	fi
}

echo '- Silver Sparrow Detection/Prevention'
echo '====================================================='

#remove existing copies of detection.txt
rm -f $PWD\detection.txt

#declare processor type
if [ $(uname -m) = 'x86_64' ] 
then
	echo "- Processor type: Intel"
else
	echo "- Processor type: Apple Mx"
fi

#capture/declare name of logged-in user
while [ -z ${varUser+x} ]
do
	varUser=$(ps aux | grep Finder | grep -v grep | grep -v '^_' | awk '{print $1}' | head -1)
	sleep 5
done
echo "- Logged-in user: $varUser"

#search for files
varMatches=0

#universal signs of infection
# -- both versions
testFiles "/tmp/agent.sh" "Both versions"
testFiles "/tmp/version.json" "Both versions"
testFiles "/tmp/version.plist" "Both versions"
# -- version 1
testFiles "/tmp/agent" "v1"
testFiles "/Users/$varUser/Library/Application Support/agent_updater/agent.sh" "v1"
testFiles "/Users/$varUser/Library/Launchagents/agent.plist" "v1"
testFiles "/Users/$varUser/Library/Launchagents/init_agent.plist" "v1"
# -- version 2
testFiles "/tmp/verx" "v2"
testFiles "/Users/$varUser/Library/Application Support/verx_updater/verx.sh" "v2"
testFiles "/Users/$varUser/Library/Application Support/verx_updater/verx.plist" "v2"
testFiles "/Users/$varUser/Library/Application Support/verx_updater/init_verx.plist" "v2"

#respond
if [ "$varMatches" -eq "0" ]
then
	echo '- No matches were found on this device!'
elif [ "$varMatches" -ge "3" ]
then
	echo '- ALERT: Number of matches is three or greater.'
	echo '  This indicates a high likelihood of infection with Silver Sparrow.'
else
	echo '- NOTICE: Number of matches is fewer than three.'
	echo '  Whilst vigilance is recommended, there is a chance this is a false positive match.'
	echo '  Please scrutinise closely the results in the logfile.'
fi

if [ "$varMatches" -ge "1" ]
then
	echo '- Location of results logfile:'
	echo "  $PWD\detection.txt"
fi

#place the inoculation file
>/Users/$varUser/Library/._insu
echo "- Placed Silver Sparrow self-destruct file at /Users/$varUser/Library/._insu"

#conclude
echo '====================================================='
echo '- Script concluded.'
if [ -z ${CS_CC_HOST+x} ]
then
	echo '  Monitor for infections via presence of the following text file on scanned devices:'
	echo "  $PWD\detection.txt"
else
	echo '  To monitor for infections, set up a File/Folder Size Monitor in Datto RMM with these parameters:'
	echo "  Files named: $PWD\detection.txt"
	echo "  Is over:     0MB for a period of 1 minutes"
fi

if [ "$varMatches" -eq "0" ]
then
	exit
else
	exit 1
fi
