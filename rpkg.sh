#!/bin/bash
# Author: Jan Lagarden
# script to install packages in a way they can be uninstalled easyly

UNISTALLDIR = "/Users/Shared/.rpkg"
COMMAND = $1
PKG
RECIEPT = $(lsbom $(pkgutil --bom $PKG)) 
UNRECIEPT

if [[ COMMAND == "-h"  || COMMAND == "--help" || COMMAND == "help" ]]
then
	echo "$0 [ -h --help help] 			to display help\n"
	echo "use $0 [ -i --install install] pkg  	to install pkg\n"
	echo "use $0 [ -r --remove remove] pkg 		to remove pkg\n"
	echo "use $0 [ -l --list list] 			to listall possible packages\n"

fi

if [[ COMMAND == "-l" || COMMAND == "--list" || COMMAND == "list" ]]
then
	for obj in $(ls UNISTALLDIR)
	do
		name = $(basename "$obj")
		echo = "${name%.uninstall}"
	done
fi

if [[ COMMAND == "-i" || COMMAND == "--install" || COMMAND == "install" ]]
then
	PKG = $2

fi

for obj in RECIEPT
do
	if [ -e $obj ]
	then
		echo "file $obj allready exists!"		
	else
		UNRECIEPT = $UNRECIEPT + $obj

	fi
done

if [[ ! -e $UNINSTALLDIR ]] 
then
 mkdir UNISTALLDIR
fi

UNRECIEPT > "$UNINSTALLDIR/$PKG.uninstall"

