type="--type"
padding_left="<span size='6.5pt'> </span>"
inf_style="$padding_left<span size='11pt'>"
case "$1" in 
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
