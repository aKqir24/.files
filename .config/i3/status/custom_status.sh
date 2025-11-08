# option placeholder ( I'm to lazy to remove it.)
type="--type"

# programs I use with the status
terminal='alacritty'
system_monitor='btop'
bt_manager='bluetuith'
audio_mixer='pulsemixer'

# styling in status
icon_separator="<span size='4pt'> </span>"
padding_right="<span size='6pt'> </span>" 
padding_left="<span size='11pt'> </span>"
inf_style="$padding_left<span size='11pt' rise='1000'>"

tui_launch() {
    pkill -x "$1" 2>/dev/null ; $terminal --title "$1" -e "$1" & sleep 0.2
    i3-msg "[title=\"^${1}\$\"] floating enable" >/dev/null
}

case "$1" in
	"$type=monitor")
		check() { xset q | grep -q "timeout:  0" && $1 || $2 ;}
		case "$2" in
			"audio") tui_launch $audio_mixer ;;
			"system") tui_launch $system_monitor ;;
			"bluetooth") tui_launch $bt_manager ;;
			"screen") check "xset s on +dpms s blank" "xset s off -dpms s noblank";;
			*) check "echo ${padding_left}<span> 󱎴 </span>" "echo ${padding_left}<span> 󰍹 </span>"
		esac
	;;
	"$type=wifi")
	INTERFACE=$(ip -o link show | awk -F': ' '/wlx/ {print $2}')
	if [ ! -z $(which iwctl) ]; then	
		wifi_ssid="$(iwctl station $INTERFACE show | sed -n 's/.*Connected network *//p' | sed 's/^ *//;s/ *$//')"
		wifi_check="$(iwctl station "$INTERFACE" show | grep 'State' | awk '{print $2}')"
		wifi_speed="$(iwctl station "$INTERFACE" show | grep 'AverageRSSI' | awk '{print $2}')"
	fi
	
	case "$wifi_check" in
		"connected")
		if [ $wifi_speed -gt -50 ]; then
			wifi_speed_icon="󰤨" 
		elif [ $wifi_speed -gt -60 ]; then
			wifi_speed_icon="󰤥"
		elif [ $wifi_speed -gt -70 ]; then
			wifi_speed_icon="󰤢"
		elif [ $wifi_speed -gt -80 ]; then
			wifi_speed_icon="󰤟"
		else 
			wifi_speed_icon="󰤯"
		fi
		[ -z "$wifi_ssid" ] || echo "<span rise='2900'>$padding_left $wifi_speed_icon <span rise='3000'>$icon_separator $wifi_ssid$padding_right</span></span>"
		;;
		"disconnected") echo "$padding_left<span> 󰤭 </span>$padding_right" ;;
		*) echo "$padding_left<span> 󰤮 </span>$padding_right"
	esac
	;;
	"$type=bluetooth")
	case "$2" in
		"manage") tui_launch $bt_manager ;;
		"toggle")
		if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
		then
			bluetoothctl power on
		else
			bluetoothctl power off
		fi
		;;
		*)	
		if [ ! -z $(which bluetoothctl) ]; then	
			inf_name=$(echo "<span rise='1000'>$(bluetoothctl info | grep "Name" | cut -d ' ' -f2-)</span>")
			inf_icon=$(bluetoothctl info | grep "Icon" | awk '{print $2}')
			
			if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]; then
				echo "$padding_left$inf_style󰂲</span>$padding_right"
			else
				case "$inf_icon" in
					"audio-headphones") echo "$inf_style 󰋋 󰂯 $icon_separator</span>$inf_name";;
					"audio-headset") echo "$inf_style 󰋎 󰂯 $icon_separator</span>$inf_name" ;;
					"phone") echo "$inf_style 󰄜 󰂯 $icon_separator</span>$inf_name";;
					*)
						if [ ! -z "$inf_icon" ]; then
							echo "$inf_style 󰂯 $icon_separator</span>$inf_name$padding_right"
						else
							echo "$padding_left$inf_style󰂯</span>$padding_right"
						fi
				esac
			fi
		else
			echo "$inf_style 󰂲</span>"
		fi
	esac
	;;
	"$type=date") echo "<span size='5pt'> </span><span size='10pt'>  󰥔 </span><span> $(date +'%I:%M %p')</span><span size='5pt'> </span>";;
	"$type=time") echo "<span size='6pt'> </span><span size='10pt'>  󰃮 </span><span> $(date +'%m-%d-%Y')</span><span size='6pt'> </span>";;
	*) echo "Option not Identified!!"
esac
