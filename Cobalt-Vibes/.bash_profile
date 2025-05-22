#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -d "$HOME/adb-fastboot/platform-tools" ] ; then
 export PATH="$HOME/adb-fastboot/platform-tools:$PATH"
fi

# Start audio exernally
while ! pgrep -x wireplumber; do
	sh ~/.config/sway/start.sh audio &> /dev/null 
done
clear
