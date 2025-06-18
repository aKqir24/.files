# i3status-rust
python3 ~/.config/i3/theming/i3bar.py \
	-c ~/.config/i3/status/config.toml -i ~/.cache/wal/colors.json

# Alacritty
sh ~/.config/i3/theming/alacritty.sh

# Rofi Launcher
sh ~/.config/i3/theming/rofi.sh

# Solid Color wallapaper
. "${HOME}/.cache/wal/colors.sh"; xsetroot -solid "$color8"

# Firefox Based Browsers
pywalfox update ; pywalfox dark &

# GTK Theme colors
[ -e ~/.themes/FlatColor ] || cp -r ~/.config/i3/theming/gtk/FlatColor ~/.themes/
sh ~/.config/i3/theming/gtk/gen_gtk_2.sh
sh ~/.config/i3/theming/gtk/gen_gtk_3.sh
sh ~/.config/i3/theming/gtk/gen_gtk_3.20.sh
killall -HUP xsettingsd || xsettingsd &
