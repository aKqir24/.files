#!/usr/bin/sh

# Set display resolution
xrandr --newmode "1152x864_60.00"   81.75  1152 1216 1336 1520  864 867 871 897 -hsync +vsync ;
xrandr --addmode VGA1 "1152x864_60.00" ; xrandr --output VGA1 --mode "1152x864_60.00" 
xsetroot -cursor_name left_ptr &

# Setup theme and icons
bash $HOME/.files/resources/scripts/pywal16_scripts/walset.sh --load
source $HOME/.cache/wal/colors-tty.sh >/dev/null

# Preload default browser
if ! pgrep -x zen-bin; then
	zen-browser --headless &>/dev/null && sleep 2
	while pgrep -x zen-bin; do
		pkill zen-bin &>/dev/null
	done
fi

# Launch WM
exec i3
