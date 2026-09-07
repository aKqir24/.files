#!/bin/bash

#############################
# Configuration
#############################

refresh=true 

#############################
# Main Execution Loop
#############################

while [ "$refresh" = true ]; do

  #############################
  # Device List Retrieval
  #############################

  connected_device_list=$(bluetoothctl devices Connected | sed 's/Device //g' | sed 's/./ 󰂱  /18')
  connected_device_mac="$(echo "$connected_device_list" | sed 's/ .*//g')"
  paired_device_list=$(bluetoothctl devices Paired | sed 's/Device //g' | sed 's/./   /18')
  paired_device_mac="$(echo "$paired_device_list" | sed 's/ .*//g')"
  device_list=$(bluetoothctl devices | sed '/..-..-..-..-..-../d' | sed 's/^.*Device //g' | sed 's/./ 󰂯  /18')

  #############################
  # List Filtering & Cleanup
  #############################

  for i in $paired_device_mac; do 
    device_list=$(echo "$device_list" | sed -e "/$i/d") 
  done
  
  for i in $connected_device_mac; do 
     paired_device_list=$(bluetoothctl devices Paired | sed 's/Device //g' | sed 's/./   /18') 
  done
  
  #############################
  # Final List Compilation
  #############################

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
  elif [[ -z "$paired_device_list" ]]; then	
    final_device_list="$device_list"
  else
	if [[ $connected_device_mac == "$paired_device_mac" ]]; then
		paired_device_list=""
	else
		paired_device_list="\n$paired_device_list"
	fi
	if [[ $device_list == "" ]]; then
		final_device_list="$connected_device_list$paired_device_list"	
	else
		final_device_list="$connected_device_list$paired_device_list\n$device_list"
	fi
  fi

  #############################
  # Menu State Preparation
  #############################

  connected=$(bluetoothctl show | grep 'PowerState')
  if [[ "$connected" =~ "PowerState: on" ]]; then
	if [[ $final_device_list == "" ]]; then
		refresh_message="󰂲  Disable Bluetooth\n󱛄  Refresh" 
	else
		refresh_message="󰂲  Disable Bluetooth\n󱛄  Refresh\n$final_device_list"
	fi
  elif [[ "$connected" =~ "PowerState: off" ]]; then
    refresh_message="󰂯  Enable Bluetooth"
  fi 

  #############################
  # Render Rofi Menu
  #############################

  device_selected=$(echo -e "$refresh_message" | sed 's/^..:..:..:..:..:.. //g' | rofi -replace -dmenu -i -theme $THEME_FILE -selected-row 1)
  
  #############################
  # Handle Global Options
  #############################

  if [[ "$device_selected" =~ "Refresh" ]]; then
	echo -e "$device_selected"
    refresh=true
    notify-send "Refreshing..." "Reloading the list of available bluetooth devices!!"
    bluetoothctl -t 3 scan on
  elif [[ "$device_selected" =~ "Enable Bluetooth" ]]; then
    bluetoothctl power on ; notify-send "Turning On..." "Bluetooth is now enabled!!"
    sleep 2 ; refresh=true
  else
    refresh=false
  fi
done

#############################
# Handle Device Selection
#############################

if [[ "$device_selected" =~ "Disable Bluetooth" ]]; then
  bluetoothctl power off ; notify-send "Turning Off..." "Bluetooth is now disabled!!"
elif [[ -n $device_selected ]]; then
  device_mac=$(echo -e "$final_device_list" | grep "$device_selected" | sed 's/ .*//g')
  device_name=$(echo -e "$final_device_list" | grep "$device_selected" | sed 's/^.* //g')
  echo "$device_selected"
  
  #############################
  # Determine Action Context
  #############################

  if [[ $( echo "$paired_device_mac" | grep "$device_mac" ) =~ $device_mac ]]; then
      if [[ $( echo "$connected_device_mac"| grep "$device_mac" ) =~ $device_mac ]]; then 
        paired="󰤭  Disconnect\n󰆴  Forget"
      else
        paired="󰤨  Connect\n󰆴  Forget"
      fi
  else
    paired="󰂯  Pair"
  fi
  
  if [[ $(bluetoothctl devices Trusted | sed -n 's/.*\(..:..:..:..:..:.. *\).*/\1/p' | grep "$device_mac") =~ $device_mac ]]; then
    trusted="󰌿  Disable auto-connect"
  else
    trusted="󰌾  Enable auto-connect"
  fi

  #############################
  # Render Action Sub-menu
  #############################

  device_action=$(echo -e "$paired\n$trusted" | rofi --normal-window -dmenu -i -theme $THEME_FILE -p "$device_name")
  
  #############################
  # Execute Device Action
  #############################

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
  fi
fi
