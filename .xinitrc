# Shuffles the wallpapers from the given directory folder 
export WALLPAPER=$(find ~/.config/i3/theming/wallpapers/* | shuf -n 1)
wal -i $WALLPAPER -n --cols16 lighten --out-dir ~/.config/wal
exec i3
