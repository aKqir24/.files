# i3status-rust
bash ~/.config/i3/theming/toml_theming.sh --i3status-rs ~/.config/i3/status/config.toml

# Alacritty
bash ~/.config/i3/theming/toml_theming.sh --alacritty

# Dunst
bash ~/.config/i3/theming/toml_theming.sh --dunst
pkill dunst ; dunst & 

# Rofi Launcher
sh ~/.config/i3/theming/rofi.sh

# Solid Color wallapaper
. "${HOME}/.cache/wal/colors.sh"
hsetroot -solid "$color8"

# Firefox Based Browsers
pywalfox update ; pywalfox dark &

# GTK Theme colors
sh ~/.config/i3/theming/gtk/gen_gtk_2.sh
sh ~/.config/i3/theming/gtk/gen_gtk_3.sh
sh ~/.config/i3/theming/gtk/gen_gtk_3.20.sh
killall -HUP xsettingsd || xsettingsd &
