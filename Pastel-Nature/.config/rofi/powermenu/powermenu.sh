#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#


# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"
# Options
shutdown=' '
reboot=' '
suspend=' '
logout=' '

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-theme ~/.config/rofi/powermenu/style.rasi
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$logout\n$suspend\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	if [[ $1 == '--shutdown' ]]; then
		systemctl poweroff
	elif [[ $1 == '--reboot' ]]; then
		systemctl reboot
	elif [[ $1 == '--suspend' ]]; then
		systemctl suspend
	elif [[ $1 == '--logout' ]]; then
		# Openbox
		# openbox --exit
		
		# bspwm
		bspc quit
		
		# i3wm
		#i3-msg exit

		# Plasma
		#qdbus org.kde.ksmserver /KSMServer logout 0 0 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
