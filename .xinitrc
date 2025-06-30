bash $HOME/pywal16_scripts/walsetup.sh
bash $HOME/pywal16_scripts/waloml.sh --alacritty
bash $HOME/pywal16_scripts/waloml.sh --i3status-rs ~/.files/.config/i3/status/config.toml
bash $HOME//pywal16_scripts/waloml.sh --dunst
pkill dunst ; dunst &
source ~/.config/wal/colors-tty.sh
exec i3
