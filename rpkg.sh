#!/bin/bash
# Author: Jan Lagarden
# script to install packages in a way they can be uninstalled easyly

UNINSTALLDIR="/Users/Shared/.rpkg"
COMMAND=$1
UNRECIEPT=""
# chack if argument exists
function argexists {
	if [ -z "$1" ]
	then
		echo "wrong usage: type $0  -h"
		exit 1
	fi
}

# create directory for unistall files if it doesn' t exist
mkdir -p  "$UNINSTALLDIR"

# check for right usage
argexists $1

# -h --help --help option
if [[ $COMMAND == "-h"  || $COMMAND == "--help" || $COMMAND == "help" ]]
then
	echo "overview of existing commands:"
	echo "use: $0 [ -h --help help]				to display help"
	echo "use: $0 [ -i --install install] <file.pkg>		to install pkg"
	echo "use: $0 [ -r --remove remove] <file.pkg>			to remove pkg"
	echo "use: $0 [ -l --list list]				to listall possible packages"
	
	exit 0
fi

# -l --list list option
if [[ $COMMAND == "-l" || $COMMAND == "--list" || $COMMAND == "list" ]]
then
	for obj in $(ls "$UNINSTALLDIR")
	do
		name=$(basename "$obj")
		echo "${name%.uninstall}"
	done
	exit 0
fi

# -i --install install option
if [[ $COMMAND == "-i" || $COMMAND == "--install" || $COMMAND == "install" ]]
then
	path="$(pwd)"
	cd /
	argexists $2
	PKG="$2"
	RECIEPT=$(lsbom -p f $(pkgutil --bom $PKG)) 
	# loop over bom to check fi fiels already exist 
	for obj in $RECIEPT
	do
		if [ -e $obj ]
		then
			echo "file $obj allready exists!"		
		else
			UNRECIEPT="$UNRECIEPT$obj "

		fi
	done
	# create unistall file
	echo "$UNRECIEPT"
	echo "$UNINSTALLDIR/$(basename $PKG).uninstall"
	echo "$UNRECIEPT" > "$UNINSTALLDIR/$(basename $PKG).uninstall"

	cd $path
	/System/Library/CoreServices/Installer.app/Contents/MacOS/Installer $2
	exit 0
fi

# -r --remove remove option
if [[ $COMMAND == "-r" || $COMMAND == "--remove" || $COMMAND == "remove" ]]
then
	path="$(pwd)"
	cd /
	argexists $2
	PKG="$2"
	UNRECIEPT=$(cat "$UNINSTALLDIR/$PKG.uninstall")
	
	for obj in $UNRECIEPT
	do
		if [[ ! -e "$obj" ]]
		then
			echo "$obj does not exist"
			continue
		else
			sudo rm -rf "$obj"
		fi
	done
	
	sudo rm -rf "$UNINSTALLDIR/$PKG.uninstall"
	cd "$path"
	exit 0
fi

echo "wrong usage! type: $0 -h"
echo "to display help"
exit 0

