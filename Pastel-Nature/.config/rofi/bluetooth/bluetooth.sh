#!/bin/bash
refresh=true ; ROFI_THEME=~/.config/rofi/bluetooth/style.rasi
REFRESH_ICON=''; BLUETOOTH_ON='󰂯' ; BLUETOOTH_OFF='󰂲'
while ($refresh == true) 
do

  connected_device_list=$(bluetoothctl devices Connected | sed 's/Device //g' | sed 's/./ 󰂱  /18')
  connected_device_mac=$(echo "$connected_device_list" | sed 's/ .*//g' )
  paired_device_list=$(bluetoothctl devices Paired | sed 's/Device //g' | sed 's/./   /18')
  paired_device_mac=$(echo "$paired_device_list" |  sed 's/ .*//g' ) 
  device_list=$(bluetoothctl devices | sed '/..-..-..-..-..-../d' | sed 's/^.*Device //g' )

  for i in $paired_device_mac
  do 
    device_list=$(echo "$device_list" | sed -e "/$i/d") 
  done
  
  for i in $connected_device_mac
  do 
     paired_device_list=$(bluetoothctl devices Paired | sed 's/Device //g' | sed 's/./   /18') 
  done
  
  if [[ -z $connected_device_list ]]; then
	if [[ $device_list == "" ]]; then
		final_device_list="$paired_device_list"
	else
		if [[ $paired_device_list == "" ]]; then
			final_device_list="$device_list"
		else
			final_device_list="$paired_device_list\n$device_list"
		fi
	fi
  elif [[ -z paired_device_list ]]; then	
    final_device_list="$device_list"
  else
	if [[ $connected_device_mac == $paired_device_mac ]]; then
		paired_device_list=""
	else
		paired_device_list=\n$paired_device_list
	fi
	if [[ $device_list == "" ]]; then
		final_device_list="$connected_device_list$paired_device_list"	
	else
		final_device_list="$connected_device_list$paired_device_list\n$device_list"
	fi
  fi

  connected=$(bluetoothctl show | grep 'PowerState')
  if [[ "$connected" =~ "PowerState: on" ]]; then
	if [[ $final_device_list == "" ]]; then
		refresh_message="$BLUETOOTH_OFF Disable Bluetooth\n$REFRESH_ICON Refresh" 
	else
		refresh_message="$BLUETOOTH_OFF Disable Bluetooth\n$REFRESH_ICON Refresh\n$final_device_list"
	fi
  elif [[ "$connected" =~ "PowerState: off" ]]; then
    refresh_message="$BLUETOOTH_ON Enable Bluetooth"
  fi 

  device_selected=$(echo -e "$refresh_message" | sed 's/^..:..:..:..:..:.. //g' | rofi -replace -dmenu -i -theme $ROFI_THEME -selected-row 1) 

  if [[ "$device_selected" =~ "$REFRESH_ICON Refresh" ]]; then
    refresh=true
    notify-send "Refreshing..." "Reloading the list of available bluetooth devices!!"
    bluetoothctl -t 3 scan on
  elif [[ "$device_selected" =~ "$BLUETOOTH_ON Enable Bluetooth" ]]; then
    bluetoothctl power on ; notify-send "Turning On..." "Bluetooth is now enabled!!"
    sleep 2 ; refresh=true
  else
    refresh=false
  fi
done

if [[ "$device_selected" =~ "$BLUETOOTH_OFF Disable Bluetooth" ]]; then
  bluetoothctl power off ; notify-send "Turning Off..." "Bluetooth is now disabled!!"
elif [[ -n $device_selected ]]; then
  device_mac=$(echo -e "$final_device_list" | grep "$device_selected" | sed 's/ .*//g')
  device_name=$(echo -e "$final_device_list" | grep "$device_selected" | sed 's/^.* //g')
  echo $device_selected
  if [[ $( echo "$paired_device_mac" | grep "$device_mac" ) =~ "$device_mac" ]]; then
      if [[ $( echo "$connected_device_mac"| grep "$device_mac" ) =~ "$device_mac" ]]; then 
        paired="Disconnect\nForget"
      else
        paired="Connect\nForget"
      fi
  else
    paired="Pair"
  fi
  
  if [[ $(bluetoothctl devices Trusted | sed -n 's/.*\(..:..:..:..:..:.. *\).*/\1/p' | grep "$device_mac") =~ "$device_mac" ]]; then
    trusted="Disable auto-connect"
  else
    trusted="Enable auto-connect"
  fi

  device_action=$(echo -e "$paired\n$trusted" | rofi -dmenu -i -theme $ROFI_THEME -p $device_name)
  if [[ "$device_action" =~ "Pair" ]]; then
    bluetoothctl pairable on
    if bluetoothctl pair "$device_mac"; then
      if bluetoothctl connect "$device_mac"; then
          notify-send "Bluetooth Connection is..." "Paired and connectted to $device_selected"
      else
          notify-send "Bluetooth Connection is..." "Paired but unable to connect to $device_selected"
      fi
    else
      notify-send "Pairing failed with $device_selected"
    fi
    bluetoothctl pairable off
  elif [[ "$device_action" =~ "Connect" ]]; then
    if bluetoothctl connect "$device_mac"; then
        notify-send "Bluetooth Connection is..." "Successfull and now connected to ${device_selected:3}!!"
    else
        notify-send "Bluetooth Connection is..." "Unsucessfull and was unable to connect to ${device_selected:3}!!"
    fi
  elif [[ "$device_action" =~ "Disconnect" ]]; then
    bluetoothctl disconnect "$device_mac" && notify-send "Disconnected from ${device_selected:3}"
  elif [[ "$device_action" =~ "Enable auto-connect" ]]; then
    bluetoothctl trust "$device_mac" && notify-send "Auto-connection enabled"
  elif [[ "$device_action" =~ "Disable auto-connect" ]]; then
    bluetoothctl untrust "$device_mac" && notify-send "Auto-connection disabled"
  elif [[ "$device_action" =~ "Forget" ]]; then
    bluetoothctl remove "$device_mac" && notify-send "${device_selected:3} Forgotten!!"
  else
    continue
  fi
else
  continue
fi
