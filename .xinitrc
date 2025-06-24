# Shuffles the wallpapers from the given directory folder 
WALLPAPER=$(find ~/.config/i3/theming/wallpapers/* | shuf -n 1)
wal -i $WALLPAPER -n --cols16 lighten
exec i3
