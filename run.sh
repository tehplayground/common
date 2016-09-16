#!/bin/bash

# Hi! You've found the script that runs the code
# This file is responsible for downloading the code to run
# and then sets all the limits, and does the actual execution

# Reading the code in from STDIN and save it to a local file
# Yes, this means that Teh Playground only supports 64k worth of code per run!
read -N65535 STDIN

# Set some limits for you hax0rs to try to get around
ulimit -c 0 -f 10 -t 10 -u 100 -x 5

# Run the raw code via PHP
# /php will always be a symlink to the correct binary, whether it be PHP or HHVM etc
# Using GNU timeout to set soft and hard runtime limits of 5 and 10 seconds respectively
# That echo also looks like a neat attack vector!
echo "$STDIN" | timeout -k 1 5 /php

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

