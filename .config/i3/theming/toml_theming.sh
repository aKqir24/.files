
#!/bin/sh

# Function to display error and quit
die() { printf "ERR: %s\n" "$1" >&2 ; exit 1; }

# Function to echo while in process
process() { echo "[\031[$1]: \033[Applied!!"; }

# Function to change toml string value
write_toml() { echo Applying Colorscheme... ; tomlq -i -t "$1" "$DEFAULT_CONFIG_FILE"; }

# Load pywal colors
if . "${HOME}/.cache/wal/colors.sh"; then
  echo "Wal Colors Script Found!!, exporting..."
else
  die "Wal colors not found, exiting script. Have you executed Wal before?"
fi
changeI3status_rustCONF () {
	write_toml "idle_bg = \"$color0\""
	write_toml "idle_fg = \"$color15\""
	write_toml "info_bg = \"$color15\""
	write_toml "info_fg = \"$color0\""
	write_toml "good_bg = \"$color2\""
	write_toml "good_fg = \"$color0\""
	write_toml "warning_bg = \"$color3\""
	write_toml "warning_fg = \"$color0\""
	write_toml "critical_bg = \"$color1\""
	write_toml "critical_fg = \"$color0\""
	write_toml "alternating_tint_bg = \"$color0\""
	write_toml "alternating_tint_fg = \"$color0\""
}

# Dunst config writer
changeDunstCONF() {
	write_toml ".global.background = \"$color0\""
	write_toml ".global.foreground = \"$color15\""
	write_toml ".global.frame_color = \"$color2\""

	write_toml ".urgency_low.background = \"$color0\""
	write_toml ".urgency_low.foreground = \"$color15\""
	write_toml ".urgency_low.frame_color = \"$color3\""

	write_toml ".urgency_critical.background = \"$color0\""
	write_toml ".urgency_critical.foreground = \"$color15\""
	write_toml ".urgency_critical.frame_color = \"$color1\""
}

# Alacritty config writer
changeAlacrittyCONF() {
	write_toml ".colors.primary.background = \"$color0\""
	write_toml ".colors.primary.foreground = \"$color15\""
	write_toml ".colors.cursor.text = \"$color0\""
	write_toml ".colors.cursor.cursor = \"$color7\""
	write_toml ".colors.vi_mode_cursor.text = \"$color0\""
	write_toml ".colors.vi_mode_cursor.cursor = \"$color15\""
	write_toml ".colors.search.matches.foreground = \"$color0\""
	write_toml ".colors.search.matches.background = \"$color15\""
	write_toml ".colors.search.focused_match.foreground = \"CellBackground\""
	write_toml ".colors.search.focused_match.background = \"CellForeground\""
	write_toml ".colors.line_indicator.foreground = \"None\""
	write_toml ".colors.line_indicator.background = \"None\""
	write_toml ".colors.footer_bar.foreground = \"$color15\""
	write_toml ".colors.footer_bar.background = \"$color7\""
	write_toml ".colors.selection.text = \"CellBackground\""
	write_toml ".colors.selection.background = \"CellForeground\""

	write_toml ".colors.normal.black = \"$color0\""
	write_toml ".colors.normal.red = \"$color1\""
	write_toml ".colors.normal.green = \"$color2\""
	write_toml ".colors.normal.yellow = \"$color3\""
	write_toml ".colors.normal.blue = \"$color4\""
	write_toml ".colors.normal.magenta = \"$color5\""
	write_toml ".colors.normal.cyan = \"$color6\""
	write_toml ".colors.normal.white = \"$color7\""

	write_toml ".colors.bright.black = \"$color8\""
	write_toml ".colors.bright.red = \"$color9\""
	write_toml ".colors.bright.green = \"$color10\""
	write_toml ".colors.bright.yellow = \"$color11\""
	write_toml ".colors.bright.blue = \"$color12\""
	write_toml ".colors.bright.magenta = \"$color13\""
	write_toml ".colors.bright.cyan = \"$color14\""
	write_toml ".colors.bright.white = \"$color15\""
}

# Determine which config to apply
case "$1" in
	--alacritty)
		[ -z "$2" ] && DEFAULT_CONFIG_FILE="$HOME/.config/alacritty.toml" || DEFAULT_CONFIG_FILE="$2"
		changeAlacrittyCONF 
		;;
	--dunst)
		[ -z "$2" ] && DEFAULT_CONFIG_FILE="$HOME/.config/dunst/dunstrc" || DEFAULT_CONFIG_FILE="$2"
		changeDunstCONF
		;;
	--i3status-rs0)
		[ -z "$2" ] && DEFAULT_CONFIG_FILE="$HOME/.config/i3status-rs/config.toml" || DEFAULT_CONFIG_FILE="$2"
		changeI3status_rustCONF
		;;
	*)
		echo "Usage: $0 --alacritty [CONFIG] | --dunst [CONFIG] | --i3status-rs [CONFIG]"
		;;
esac

