# option placeholder ( I'm to lazy to remove it.)
type="--type"

# programs I use with the status
terminal='alacritty'
system_monitor='btop'
bt_manager='bluetuith'

# styling in status
padding_left="<span size='9.1pt'> </span>"
inf_style="$padding_left<span size='11pt'>"

tui_launch() {
	pkill $1 ;
	bash -c "$terminal --title ${1} -e ${1} & sleep 0.16;
	i3-msg \"[title=\\\"${1}\\\"] floating enable\""
}

case "$1" in
	"$type=monitor")
		check() { xset q | grep -q "timeout:  0" && $1 || $2 ;}
		case "$2" in
			"system") tui_launch $system_monitor ;;
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
		[ -z "$wifi_ssid" ] || echo "$padding_left $wifi_speed_icon <span> $wifi_ssid</span>"
		;;
		"disconnected") echo "$padding_left<span> 󰤭 </span>" ;;
		*) echo "$padding_left<span> 󰤮 </span>"
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
			inf_name=$(echo "$(bluetoothctl info | grep "Name" | cut -d ' ' -f2-)")
			inf_icon=$(bluetoothctl info | grep "Icon" | awk '{print $2}')
			
			if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]; then
				echo "$inf_style 󰂲</span> "
			else
				case "$inf_icon" in
					"audio-headphones") echo "$inf_style 󰋋 󰂯 </span><span>$inf_name</span>";;
					"audio-headset") echo "$inf_style 󰋎 󰂯 </span><span>$inf_name</span>" ;;
					"phone") echo "$inf_style 󰄜 󰂯 </span><span>$inf_name</span>";;
					*)
						if [ ! -z "$inf_icon" ]; then
							echo "$inf_style 󰂯 </span><span>$inf_name</span>"
						else
							echo "$inf_style 󰂯</span>"
						fi
				esac
			fi
		else
			echo "$inf_style 󰂲</span>"
		fi
	esac
	;;
	"$type=date") echo "<span size='10pt'>  󰥔 </span><span> $(date +'%I:%M %p')</span>";;
	"$type=time") echo "<span size='10pt'>  󰃮 </span><span> $(date +'%m-%d-%Y')</span>";;
	*) echo "Option not Identified!!"
esac
