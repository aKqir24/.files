#!/bin/sh
inf_name=$(echo "%{F#E3ECEA}$(bluetoothctl info | grep "Name" | cut -d ' ' -f2-)")
inf_icon=$(bluetoothctl info | grep "Icon" | awk '{print $2}')
if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]; then
	echo "%{F#9EA5A3}"
else
 if [[ $inf_icon == "audio-headphones" ]]; then
	echo "%{F#9FD8A6}%{T2} %{T-}$inf_name"
 elif [[ $inf_icon == "phone" ]]; then
	echo "%{F#9FD8A6}%{T2} %{T-}$inf_name"
 else
	echo "%{F#9FD8A6}"
 fi
fi
