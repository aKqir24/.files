#!/usr/bin/sh

# start audio session
if [ "$1" = "audio" ]; then
	for audio in pipewire wireplumber pipewire-pulse; do
		pkill ${audio} ; ${audio} &
	done

# launch the screenshot tool from call
elif [ "$1" = "screenshot" ]; then 
	file_name=$(date +"%Y-%m-%d_%H-%M-%S").png
	image_dir=$HOME/Pictures/Screenshots/$file_name

	pgrep -x slurp || 
		grim -t png -l 9 -g "$(slurp)" -c $image_dir

	if pgrep -x slurp; then
		echo " "
	else
		dustctl close-all ;
		notify-send "Screenshot taken..." \
		"( $file_name ) has been saved!!"
	fi
fi
