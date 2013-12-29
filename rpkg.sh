#!/bin/bash
# Author: Jan Lagarden
# script to install packages in a way they can be uninstalled easyly

UNISTALLDIR="/Users/Shared/.rpkg"
COMMAND=$1
UNRECIEPT=""

# chack if argument exists
function argexists {
	if [ -z "$1" ]
	then
		echo "wrong usage: type  rpkg.sh -h"
		exit 1
	fi
}

# create directory for unistall files if it doesn' t exist
mkdir -p  "$UNISTALLDIR"

# check for right usage
argexists $1

# -h --help --help option
if [[ $COMMAND == "-h"  || $COMMAND == "--help" || $COMMAND == "help" ]]
then
	echo "$0 [ -h --help help] 			to display help\n"
	echo "use $0 [ -i --install install] pkg  	to install pkg\n"
	echo "use $0 [ -r --remove remove] pkg 		to remove pkg\n"
	echo "use $0 [ -l --list list] 			to listall possible packages\n"
	
	exit 0
fi

# -l --list list option
if [[ $COMMAND == "-l" || $COMMAND == "--list" || $COMMAND == "list" ]]
then
	for obj in $(ls UNISTALLDIR)
	do
		name = $(basename "$obj")
		echo = "${name%.uninstall}"
	done
	exit 0
fi

# -i --install install option
if [[ COMMAND == "-i" || COMMAND == "--install" || COMMAND == "install" ]]
then
	argexists $2
	$PKG = "$2"
	RECIEPT=$(lsbom $(pkgutil --bom $PKG)) 
	# loop over bom to check fi fiels already exist 
	for obj in $RECIEPT
	do
		if [ -e $obj ]
		then
			echo "file $obj allready exists!"		
		else
			$UNRECIEPT = $UNRECIEPT + $obj

		fi
	done
	# create unistall file
	$UNRECIEPT > "$UNINSTALLDIR/$PKG.uninstall"
	exit 0
fi

# -r --remove remove option
if [[ COMMAND == "-r" || COMMAND == "--remove" || COMMAND == "remove" ]]
then
	argexists $2
	$PKG = "$2"
	RECIEPT=$(lsbom $(pkgutil --bom $PKG)) 
	$(cat "$UNINSTALLDIR/$PKG.uninstall")  > $UNRECIEPT
	
	for obj in $UNRECIEPT
	do
		if [ -e $obj ]
		then
			continue
		fi
		rm -rf $obj
	done 
	exit 0
fi
