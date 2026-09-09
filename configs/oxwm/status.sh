#!/usr/bin/env bash
# Plain-text status segments for the oxwm bar (no Pango markup).
# Emits comma-free plain text; colors handled by oxwm block settings.

cpu() {
	local cache="/tmp/oxwm_cpu_stat"
	local cpu u n s i io ir si st total idle
	local prev_total prev_idle diff_total diff_idle pct
	read -r cpu u n s i io ir si st _ < /proc/stat
	total=$((u + n + s + i + io + ir + si + st))
	idle=$((i + io))
	if [ -f "$cache" ]; then
		read -r prev_total prev_idle < "$cache"
		diff_total=$((total - prev_total))
		diff_idle=$((idle - prev_idle))
		if [ "$diff_total" -gt 0 ]; then
			pct=$(( (100 * (diff_total - diff_idle)) / diff_total ))
			[ "$pct" -lt 0 ] && pct=0
			[ "$pct" -gt 100 ] && pct=100
		else
			pct=0
		fi
	else
		pct=0
	fi
	printf '%d %d' "$total" "$idle" > "$cache"
	printf '\uf4bc  %d%%' "$pct"
}

mem() {
	local pct
	pct=$(awk '/^MemTotal/{t=$2} /^MemAvailable/{a=$2} END{printf "%.0f", (t-a)/t*100}' /proc/meminfo)
	printf '\uefc5  %s%%' "$pct"
}

bt() {
	local powered ic name
	powered=$(bluetoothctl show 2>/dev/null | awk -F': ' '/Powered:/{print $2; exit}')
	if [ "$powered" != "yes" ]; then
		printf '\U000f00b2'
		return
	fi
	name=$(bluetoothctl info 2>/dev/null | awk -F': ' '/Name:/{print $2; exit}')
	ic=$(bluetoothctl info 2>/dev/null | awk -F': ' '/Icon:/{print $2; exit}')
	if [ -n "$name" ]; then
		case "$ic" in
			audio-headphones) printf '  \U000f02cb  \U000f00af  %s  ' "$name" ;;
			audio-headset)    printf '  \U000f02ce  \U000f00af  %s  ' "$name" ;;
			phone)            printf '  \U000f011c  \U000f00af  %s  ' "$name" ;;
			*)                printf '  \U000f00af  %s  ' "$name" ;;
		esac
	else
		printf '\U000f00af'
	fi
}

wifi() {
	local svc string name strength icon powered
	powered=$(connmanctl technologies | grep -A 5 "/net/connman/technology/wifi" | grep "Powered" | awk '{print $NF}')
	svc=$(connmanctl services 2>/dev/null | awk '$1 ~ /[OR]/ && $NF ~ /(wifi|wlan)/ { print $NF; exit }')

	state=$(printf '%s\n' "$(connmanctl state)" | awk -F'= ' '/^  State =/{print $2; exit}')
	if [ "$powered" != "True" ]; then
		printf '\U000f05a9'
		return
	fi
	if [ "$state" = "idle" ]; then
		printf '\U000f092d'
		return
	fi

	string=$(connmanctl services "$svc" 2>/dev/null)
	name=$(printf '%s\n' "$string" | awk -F'= ' '/^  Name =/{print $2; exit}')
	strength=$(printf '%s\n' "$string" | awk -F'= ' '/^  Strength =/{print $2; exit}')
	[ -z "$strength" ] && strength=0
	if   [ "${strength}" -gt 70 ]; then icon=$'\U000f0928'
	elif [ "${strength}" -gt 50 ]; then icon=$'\U000f0925'
	elif [ "${strength}" -gt 30 ]; then icon=$'\U000f0922'
	else icon=$'\U000f091f'; fi
	printf '%s  %s' "$icon" "$name"
}

net() {
	local ip
	# Hide the LAN IP while on wifi; the wifi block shows SSID instead
	if connmanctl services 2>/dev/null | awk '$1 ~ /[OR]/ && $NF ~ /(wifi|wlan)/ {found=1; exit} END{exit !found}'; then
		echo '󰅛'
		return
	fi
	ip=$(ip -4 -o addr show up 2>/dev/null | awk '$2 != "lo" && $2 !~ /^wl/ {print $4; exit}' | cut -d/ -f1)
	if [ -n "$ip" ]; then
		printf '\U000f0c53  %s' "$ip"
	else
		printf '\U000f0c53'
	fi
}

sound() {
	local out v muted icon
	out=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
	[ -z "$out" ] && out="$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null)"
	case "$out" in *MUTED*) muted=1 ;; esac
	v=$(printf '%s' "$out" | sed -n 's/.*Volume: \([0-9.]*\).*/\1/p')
	[ -z "$v" ] && v=0
	v=$(awk -v v="$v" 'BEGIN{printf "%d", v*100}')
	if [ -n "$muted" ]; then
		icon=$'\U000f075f'
		v=0
	elif [ "$v" -gt 66 ]; then icon=$'\U000f057e'
	elif [ "$v" -gt 33 ]; then icon=$'\U000f0580'
	else icon=$'\U000f057f'; fi
	printf '%s  %d%%' "$icon" "$v"
}

toggle_widget() {
	bash "$HOME/.files/configs/rofi/launch.sh" "${1}"
}

monitor() {
	if xset q 2>/dev/null | grep -q "timeout:  0"; then
		printf '\U000f13b4'
	else
		printf '\U000f0379'
	fi
}

toggle_monitor() {
	if xset q 2>/dev/null | grep -q "timeout:  0"; then
		xset s on +dpms s blank
		xset s 600
	else
		xset s off -dpms s noblank
	fi
}

volume_step() {
	local pct v
	v=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | sed -n 's/.*Volume: \([0-9.]*\).*/\1/p')
	[ -z "$v" ] && v=0
	pct=$(awk -v v="$v" 'BEGIN{n = int(v*100 + 0.5) + 5; if (n > 100) n = 0; print n}')
	wpctl set-volume @DEFAULT_AUDIO_SINK@ "$pct%"
	if [ "$pct" -gt 0 ]; then
		wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
	fi
}

${1} ${2}
