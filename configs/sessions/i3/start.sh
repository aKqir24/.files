#!/usr/bin/sh

case "$1" in
	"theming")
		notify-send "Loading..." "Setting up colors & configs"
        bash $HOME/.files/resources/scripts/walset/walset.sh --load --reload
	;;
	"screenshot") # launch the screenshot tool from call
		FILENAME="$(date +"%Y-%m-%d_%H-%M-%S").png"
		IMAGE_DIR="$2$FILENAME"	 
		notifySRC() {
			dunstctl close-all &&
			notify-send "Screenshot taken..." \
			"( $FILENAME ) has been saved!!"
		}
		gscreenshot -f $IMAGE_DIR --gui
	;;
	*)
		echo "Usage: sh start.sh"
		echo "Program: audio, screenshot" 
	;;
esac
