export WINEFSYNC=1
export EDITOR=nvim
export LANG=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US:en
export XCURSOR_SIZE=14
export COLORTERM=truecolor
export TERM=xterm-256-color
export LIBSEAT_BACKEND=seatd
export $XDG_SESSION_DESKTOP=sway
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export SCRIPTS_FOLDER="$HOME/.files/resources/scripts"
export LD_LIBRARY_PATH=$PWD/bin:$LD_LIBRARY_PATH

if [ "$XDG_SESSION_DESKTOP" = "sway" ] ; then
    # https://github.com/swaywm/sway/issues/595
    export _JAVA_AWT_WM_NONREPARENTING=1
fi
