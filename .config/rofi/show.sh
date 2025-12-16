#!/bin/sh

SCRIPT_PATH="$(dirname "$0")/scripts"

if [ ! -e "$SCRIPT_PATH/$1.sh" ]; then
	echo "$0: '$1' is not included in the scripts"
	echo "The availble one is: wifi, bluetooth, emoji, launcher, powermenu"
else
	case $1 in	
		"emoji") "$SCRIPT_PATH/$1.sh" || \
			echo "$0: 'rofi-emoji' is not installed, please install it!!";;
		*) "$SCRIPT_PATH/$1.sh" ;;
	esac
fi
