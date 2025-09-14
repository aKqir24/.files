# ~/.bash_profile

# Verify & start these programs
[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f ~/.profile ]] && . ~/.profile
[ -d "$HOME/adb-fastboot/platform-tools" ] && export PATH="$HOME/adb-fastboot/platform-tools:$PATH"
[ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ] && exec startx   
