#!/bin/bash

Retro_Lime=( 
	i3
	mpv
	btop
	gimp
	rofi
	kitty
	bluez
	neovim
	gparted
	polybar
	preload
	udiskie
	pcmanfm
	viewnior
	pipewire
	siji-ttf
	xarchiver
	bluez-libs
	winetricks
	obs-studio
	bluez-utils
	imagemagick
	pulsemixer	
	wireplumber
	zenity-gtk3
	pipewire-jack
	wine-wow64-git
	xgifwallpaper
	rofi-emoji-git
	pipewire-pulse
	zen-browser-bin	
    gimp-plugin-gmic		
	picom-pijulius-next-git 
)
Teal_Girl=(
	sway
	foot
	swaybg
	swayidle
	pcmanfm
	wayland
	usdiskie
	pipewire
	viewnior
	wine-wow64
	winetricks
	wireplumber
	zenity-gtk3
	pipewire-jack
	pipewire-pulse
	rofi-emoji-git
	gimp-plugin-gmic
	noto-fonts-emoji
)

if [[ "$1" == "--retro_lime" ]]; then
	packages=$Retro_Lime
elif [[ "$1" == "--teal-cute-girl" ]]; then
	packages=$Teal_Girl
fi

for pkg in ${packages[@]}; do yay -S --noconfirm ${pkg}; done
