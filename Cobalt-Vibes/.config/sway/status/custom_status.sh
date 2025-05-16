type="--type"
case "$1" in 
	"$type=wifi")
	INTERFACE=wlan0
	wifi_ssid="$(iwctl station $INTERFACE show | sed -n 's/.*Connected network *//p' | sed 's/^ *//;s/ *$//')"
	wifi_check="$(iwctl station "$INTERFACE" show | grep 'State' | awk '{print $2}')"
	wifi_speed="$(iwctl station "$INTERFACE" show | grep 'RSSI' | awk '{print $2}')"
	if [ "$wifi_check" = "connected" ]; then
		if [ $wifi_speed -gt -50 ]; then 
			wifi_speed_icon="󰤨" 
		elif [ "$wifi_speed" -gt -60 ]; then
			wifi_speed_icon="󰤥"
		elif [ "$wifi_speed" -gt -70 ]; then
			wifi_speed_icon="󰤢"
		elif [ "$wifi_speed" -gt -80 ]; then
			wifi_speed_icon="󰤟"
		elif [ "$wifi_speed" -gt -90 ]; then 
			wifi_speed_icon="󰤯"
		fi
		[ "$wifi_ssid" = "" ] && echo  || echo " <span size='10pt'>$wifi_speed_icon </span><span> $wifi_ssid </span>"
	elif [ "$wifi_check" = "disconnected" ]; then
		echo "<span> 󰤭  </span>"
	else
		echo "<span> 󰤮  </span>"
	fi
	;;

	"$type=bluetooth")
	if [ "$2" = "" ]; then
		inf_name=$(echo "$(bluetoothctl info | grep "Name" | cut -d ' ' -f2-)")
		inf_icon=$(bluetoothctl info | grep "Icon" | awk '{print $2}')
		inf_style="<span size='11pt'>"
		if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]; then
			echo "$inf_style 󰂲 </span> "
		else
			if [[ $inf_icon == "audio-headphones" ]]; then
				echo "$inf_style󰋋 󰂯 </span> $inf_name"
			elif [[ $inf_icon == "phone" ]]; then
				echo "$inf_style󰄜 󰂯 </span> $inf_name"
			else
				echo "$inf_style 󰂯 </span>"
			fi
		fi

	elif [ "$2" = "toggle" ]; then
		if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
		then
			bluetoothctl power on
		else
			bluetoothctl power off
		fi
	fi
	;;
	"$type=date")
		echo "<span size='10pt'>󰥔 </span> $(date +'%I:%M %p')" ;;
	"$type=time")
		echo "<span size='10pt'>󰃮 </span> $(date +'%m-%d-%Y')" ;;
	*)
		echo "Error"
esac
