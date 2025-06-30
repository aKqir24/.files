# ~/.bash_profile

# Verify & start these programs
[[ -f ~/.bashrc ]] && . ~/.bashrc
[ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ] && exec startx   
[ -d "$HOME/adb-fastboot/platform-tools" ] && export PATH="$HOME/adb-fastboot/platform-tools:$PATH"

# Set display resolution
xrandr --newmode "1152x864_60.00"   81.75  1152 1216 1336 1520  864 867 871 897 -hsync +vsync ;
xrandr --addmode VGA1 "1152x864_60.00" ; xrandr --output VGA1 --mode "1152x864_60.00" & 
xsetroot -cursor_name left_ptr &


