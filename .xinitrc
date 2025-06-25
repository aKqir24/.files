# Shuffles the wallpapers from the given directory folder
export PYWAL16_OUT_DIR=~/.config/wal
export WALLPAPER=$(find $PYWAL16_OUT_DIR/theming/wallpapers/* | shuf -n 1)
wal -i $WALLPAPER -n --cols16 lighten --out-dir $PYWAL16_OUT_DIR
source ~/.config/wal/colors-tty.sh
exec i3
