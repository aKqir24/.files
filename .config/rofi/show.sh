#!/bin/sh

# Small dialog scripts using rofi
# Made by Akqir(aKqir24)
# https://github.com/aKqir24

clipboard() {
	cliphist list \
		| rofi -dmenu -i -p "󰅇 " -theme "$STYLE_FILE" \
		| cliphist decode \
		| wl-copy  | cliphist delete # change this part if you are using x11
}

emoji() {
	## Run
	rofi -modi emoji \
		 -emoji-format '{emoji}' \
		 -show emoji --emoji-mode copy \
	     -theme	$STYLE_FILE 
	
	## Paste The Emoji
	PREV_WIN=$(xdotool getwindowfocus)
	sleep 0.95
	xdotool windowfocus $PREV_WIN
	xsel --clipboard --output | xdotool type --delay 0 --file -
}

launcher() {
	## Run
	rofi -show drun --normal-window \
		-theme $STYLE_FILE
} 

powermenu() {
	# Options
	shutdown='⏻ ' reboot=' ' suspend=' ' logout=' '
	
	# Rofi CMD
	rofi_cmd() { rofi -dmenu -theme $STYLE_FILE; }
	
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

STYLE_FILE="$(dirname "$0")/styles/$1.rasi"
($1) || "$(dirname "$0")/scripts/$1.sh">/dev/null || \
	( echo "$0: '$1' is not included in the scripts";
	  echo "The availble one is: wifi, bluetooth, emoji, launcher, powermenu")
