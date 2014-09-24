#!/bin/bash

# Hi! You've found the script that runs the code
# This file is responsible for downloading the code to run
# and then sets all the limits, and does the actual execution

# Yeah this really shouldn't happen
if [ -z "$1" ]; then
	echo "No ID was provided... somehow. Make a note of it!"
	exit -1
fi

# Download the raw code into a temp file
curl -A 'Tehplayground Renderer' -sfo /render/raw https://tehplayground.com/api/code/$1/raw

# Set some limits for you hax0rs to try to get around
ulimit -c 0 -f 10 -t 10 -u 20 -x 5

# Run the raw code via PHP
# /php will always be a symlink to the correct binary, whether it be PHP or HHVM etc
# Using GNU timeout to set soft and hard runtime limits of 5 and 10 seconds respectively
timeout -k 1 5 /php /render/raw

# Show an informative error if we hit those limits
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
	echo
	if [ $RETVAL -eq 124 ]; then
		echo "Execution took longer than 5 seconds, sent SIGTERM and terminated"
	elif [ $RETVAL -eq 137 ]; then
		echo "Execution took longer than 5 seconds, and you tried catching SIGTERM so we sent SIGKILL instead, ha-ha!"
	fi
fi

