#!/usr/bin/sh

case "$1" in
	"audio") # start audio session
		for audio in pipewire wireplumber pipewire-pulse; do
			pgrep -x ${audio} || ${audio} &
		done
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
	"xdg-portal")
		pgrep -x xdg-desktop-portal && pgrep -x xdg-desktop-portal-gtk || \
			/usr/libexec/xdg-desktop-portal & /usr/libexec/xdg-desktop-portal-gtk &>/dev/null
	;;
	*)
		echo "Usage: sh start.sh"
		echo "Program: audio, screenshot" 
	;;
esac
