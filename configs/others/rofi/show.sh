#!/bin/sh

SCRIPT_PATH="$(dirname "$0")/scripts"

emoji() {
	## Run
	rofi -modi emoji \
		 -emoji-format '{emoji}' \
		 -show emoji --emoji-mode copy \
	     -theme ~/.config/rofi/styles/emoji.rasi
	
	## Paste The Emoji
	PREV_WIN=$(xdotool getwindowfocus)
	sleep 0.95
	xdotool windowfocus $PREV_WIN
	xsel --clipboard --output | xdotool type --delay 0 --file -
}

launcher() {
	## Run
	rofi -show drun --normal-window \
		-theme $HOME/.config/rofi/styles/launcher.rasi
} 

powermenu() {
	# Options
	shutdown='⏻ ' reboot=' ' suspend=' ' logout=' '
	
	# Rofi CMD
	rofi_cmd() { rofi -dmenu -theme ~/.config/rofi/styles/powermenu.rasi;}
	
	# Pass variables to rofi dmenu
	run_rofi() { echo "$logout\n$suspend\n$reboot\n$shutdown" | rofi_cmd ;}
	
	# Execute Command
	case "$(run_rofi)" in
		$shutdown) systemctl poweroff ;;
		$reboot) systemctl reboot ;;
		$suspend) systemctl suspend ;;
		$logout) i3-msg exit || sway exit ;;
	esac	
}

($1) || "$SCRIPT_PATH/$1.sh">/dev/null || \
	echo "$0: '$1' is not included in the scripts";
	echo "The availble one is: wifi, bluetooth, emoji, launcher, powermenu"
