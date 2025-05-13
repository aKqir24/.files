#!/usr/bin/env bash

# Resolution Display
xrandr --newmode "1152x864_60.00"   81.75  1152 1216 1336 1520  864 867 871 897 -hsync +vsync ;
xrandr --addmode VGA1 "1152x864_60.00" ; xrandr --output VGA1 --mode "1152x864_60.00" & 
xsetroot -cursor_name left_ptr

# Start Audio
pgrep -x pipewire || /usr/bin/pipewire &
pgrep -x pipewire-pulse || /usr/bin/pipewire-pulse &
pgrep -x wireplumber || /usr/bin/wireplumber &

# Start / Restart Program
gif_wallpaper=$HOME/.config/i3/nautr_girl.gif
for kill in sxhkd xgifwallpaper dust polybar picom ; do pgrep -x ${kill} && $(killall -q ${kill} &); done
picom & sleep 0.6 ; xgifwallpaper -s FILL --scale-filter PIXEL -d 15 $gif_wallpaper & dunst & sxhkd & polybar & 


