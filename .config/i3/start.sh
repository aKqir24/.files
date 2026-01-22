#!/usr/bin/sh

case "$1" in
	"theming")
		notify-send "Loading..." "Setting up colors & configs"
        bash $HOME/.files/resources/scripts/walset/walset.sh --load --reload
		;;
	"display")
		# Set display resolution
		xrandr --newmode "1152x864_60.00"   81.75  1152 1216 1336 1520  864 867 871 897 -hsync +vsync ;
		xrandr --addmode VGA1 "1152x864_60.00" ; xrandr --output VGA1 --mode "1152x864_60.00" 
		xsetroot -cursor_name left_ptr &
		;;
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
