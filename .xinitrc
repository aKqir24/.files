bash $HOME/pywal16_scripts/walsetup.sh
bash $HOME/pywal16_scripts/waloml.sh \
	--alacritty --dunst \
	--i3status-rs ~/.files/.config/i3/status/config.toml
bash $HOME/pywal16_scripts/theming/rofi.sh ; pgrep -x dust && pkill dunst && dunst &
source $PYWAL16_OUT_DIR/colors-tty.sh

# Set display resolution
xrandr --newmode "1152x864_60.00"   81.75  1152 1216 1336 1520  864 867 871 897 -hsync +vsync ;
xrandr --addmode VGA1 "1152x864_60.00" ; xrandr --output VGA1 --mode "1152x864_60.00" 
xsetroot -cursor_name left_ptr &

exec i3
