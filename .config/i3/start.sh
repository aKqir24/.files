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
	
	if [ ! -z $WAYLAND_DISPLAY ]; then
		pgrep -x slurp || 
			grim -t png -l 9 -g "$(slurp)" -c $IMAGE_DIR
		pgrep -x slurp && echo " " || 
	else
		import $IMAGE_DIR
	fi
 
	function notifySRC() {
		dunstctl close-all ;
		notify-send "Screenshot taken..." \
		"( $FILENAME ) has been saved!!"
	}
else
	echo "Usage: sh start.sh"
	echo "Program: audio, screenshot"
fi
