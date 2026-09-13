#!/bin/bash
# Rofi calendar widget (MD3). Pure 7-column day grid with compact top header.
# Navigation via keyboard shortcuts: [ / ] (Month), { / } (Year).
# Selecting a day copies "YYYY-MM-DD" to the clipboard and closes.

curr_year=$(date +%Y)
curr_month=$(date +%m)
curr_day=$(date +%-d)

year="$curr_year"
month="$curr_month"

accent=$(awk '/^    primary:/{gsub(";", "", $2); print $2; exit}' "$HOME/.cache/matugen/rofi-colors.rasi")
[ -z "$accent" ] && accent="#ffb4a3"

navigate() {
	read -r new_y new_m < <(date -d "$year-$month-01 $1" '+%Y %m')
}

while :; do
	month_name=$(date -d "$year-$month-01" +%B)
	first_dow=$(date -d "$year-$month-01" +%w)          # 0=Sun..6=Sat
	days_in_month=$(date -d "$year-$month-01 +1 month -1 day" +%-d)

	entries=$(mktemp)
	trap 'rm -f "$entries"' EXIT

	# Row 1: Weekday names
	printf 'Sun\nMon\nTue\nWen\nThu\nFri\nSat\n' > "$entries"

	for ((i = 0; i < first_dow; i++)); do
		printf ' \n' >> "$entries"
	done

	for ((d = 1; d <= days_in_month; d++)); do
		if [ "$d" -eq "$curr_day" ] && [ "$year" -eq "$curr_year" ] && [ "$month" -eq "$curr_month" ]; then
			printf '<span weight="bold" foreground="%s">%2d</span>\n' "$accent" "$d" >> "$entries"
		else
			printf '%2d\n' "$d" >> "$entries"
		fi
	done

	selected=$(rofi -dmenu -p '' -mesg "$month_name $year  Mon: [ ] Yr: { }" \
		-no-custom -markup-rows -theme "$ROFI_DIR/styles/calendar.rasi" \
		-kb-custom-1 "bracketleft" \
		-kb-custom-2 "bracketright" \
		-kb-custom-3 "braceleft" \
		-kb-custom-4 "braceright" \
		< "$entries")
	code=$?

	rm -f "$entries"
	trap - EXIT

	case $code in
		0)
			if [[ "$selected" =~ [0-9] ]]; then
				day=$(printf '%s' "$selected" | tr -dc '0-9')
				printf '%04d-%02d-%02d\n' "$year" "$month" "$day" | xclip -selection clipboard
				break
			else
				continue
			fi
			;;
		10) # Prev Month ([)
			navigate "-1 month"
			year=$new_y
			month=$new_m
			continue
			;;
		11) # Next Month (])
			navigate "+1 month"
			year=$new_y
			month=$new_m
			continue
			;;
		12) # Prev Year ({)
			navigate "-1 year"
			year=$new_y
			month=$new_m
			continue
			;;
		13) # Next Year (})
			navigate "+1 year"
			year=$new_y
			month=$new_m
			continue
			;;
		*)
			break
			;;
	esac
done
exit 0
