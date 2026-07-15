#!/bin/sh
set -x

case "$1" in
    "audio") # start audio session
        for audio in pipewire wireplumber pipewire-pulse; do
            pgrep -x "$audio" >/dev/null || "$audio" &
        done
    ;;
    "screenshot") # launch the screenshot tool
        FILENAME="$(date +"%Y-%m-%d_%H-%M-%S").png"
        IMAGE_DIR="$2/$FILENAME"

        gscreenshot -f "$IMAGE_DIR" --gui
        notify-send "Screenshot taken..." "( $FILENAME ) has been saved!!"
    ;;
    "xdg-portal")
        if ! pgrep -x xdg-desktop-portal >/dev/null; then
            /usr/libexec/xdg-desktop-portal &
        fi
        if ! pgrep -x xdg-desktop-portal-gtk >/dev/null; then
            /usr/libexec/xdg-desktop-portal-gtk &>/dev/null &
        fi
    ;;
    "theming")
        bash ~/.files/resources/scripts/walset/walset.sh --load &
    ;;
    "preload-zen")
        if ! pgrep -x zen-bin >/dev/null; then
            zen-browser --headless &>/dev/null &
            sleep 2
            while pgrep -x zen-bin >/dev/null; do
                pkill zen-bin &>/dev/null
            done
        fi
    ;;
    *)
        echo "Usage: sh start.sh <audio|screenshot|xdg-portal|theming|preload-zen>"
    ;;
esac
