#!/usr/bin/sh

# start audio session
if [ "$1" = "audio" ]; then
	for audio in pipewire wireplumber pipewire-pulse; do
		pgrep -x ${audio} || ${audio} &
	done

# launch the screenshot tool from call
elif [ "$1" = "screenshot" ]; then 
	FILENAME=$(date +"%Y-%m-%d_%H-%M-%S").png
	IMAGE_DIR=$2$FILENAME	
 
	function notifySRC() {
		dunstctl close-all ;
		notify-send "Screenshot taken..." \
		"( $FILENAME ) has been saved!!"
	}

	gscreenshot -f $IMAGE_DIR --gui

else
	echo "Usage: sh start.sh"
	echo "Program: audio, screenshot"
fi
