#!/bin/bash

# ===============================
# 🎨 Debian Dotfiles Installer
# ===============================

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RESET="\033[0m"
BOLD="\033[1m"

# Helper function for headers
header() {
    echo -e "\n${CYAN}=========================================${RESET}"
    echo -e "	${BOLD}${CYAN}$1${RESET}"
    echo -e "${CYAN}=========================================${RESET}\n"
}

# Warning message 
header "            ⚠️  Warning"
echo -e "${YELLOW}Setup: Please be aware that this install script"
echo -e "is made for Debian-based machines and may not work on other distros!${RESET}"
sleep 2


# ===========================
# 1 Install Base Packages
# ===========================
header "     📦 Installing Base Packages"
echo -e "${GREEN}Updating apt and installing core packages...${RESET}"
sudo apt update
sudo apt install -y \
pipewire pipewire-pulse libssl-dev wireplumber mpv automake sudo alacritty \
viewnior libtoo imagemagick xsettingsd nwg-look stow btop starship pcmanfm clang\
preload git ark gettext power-profiles-daemon fonts-noto-color-emoji \
libpulse-dev libsensors-dev libpipewire-0.3-dev libtool-bin autoconf \
libnotmuch-dev yq python3-gi python3-setuptools obexftp obexpushd \
default-jre gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
gstreamer1.0-plugins-bad gstreamer1.0-libav v4l2loopback-dkms \
xdg-desktop-portal vainfo libxapp-gtk3-module
sudo apt purge intel-media-va-driver

# ===========================
# 2 Setup dotfiles
# ===========================
header "         🗂  Dotfiles Setup"
echo -e "${GREEN}Cloning dotfiles repository...${RESET}"
[ "$(pwd)" == "${HOME}" ] || cd "${HOME}"
git clone --recurse-submodules https://github.com/aKqir24/.files.git && cd ".files"
echo -e "${GREEN}Linking base configs...${RESET}"
stow -d configs/ -t "${HOME}"/.config/ --adopt others
stow -d configs/split/ -t "${HOME}" --adopt vscodium
echo -e "${GREEN}Linking wm configs...${RESET}"
echo -e "${GREEN}Please choose a WM!\n  [1] awesomewm  \n[2] sway  \n[3] i3\n\n${RESET}"
read -p "-> " USER_WM_CH
WMS=("awesome" "sway" "i3")
case "${USER_WM_CH}" in
	1) USER_WM="awesome" 
	2) USER_WM="sway" 
	3) USER_WM="i3" 
esac
for wm  in "${WMS[@]}"; do 
	rm  -rf "${HOME}/.config/${wm}"
done
ln -sf "${HOME}/.files/configs/${USER_WM}" "${HOME}/.config/"
cd "$HOME"

# ===========================
# 3 Setup MPV thumbfast
# ===========================
header "        🎬 MPV Thumbfast Setup"
mkdir -p "$HOME/.config/mpv/scripts" "$HOME/.config/mpv/script-opts"
[[ -e "$HOME/.config/mpv/scripts/thumbfast.lua" ]] || wget -P "$HOME/.config/mpv/scripts/" \
    https://raw.githubusercontent.com/po5/thumbfast/refs/heads/master/thumbfast.lua
[[ -e "$HOME/.config/mpv/scripts-opts/thumbfast.conf" ]] || wget -P "$HOME/.config/mpv/script-opts/" \
    https://raw.githubusercontent.com/po5/thumbfast/refs/heads/master/thumbfast.conf

# ===========================
# 4️⃣ Enable System Services
# ===========================
header "   ⚙️  Configuring Systemd Services"
if [[ "$(ps -p 1 -o comm=)" == "systemd" ]]; then
	system_services=(systemd-networkd systemd-resolved power-profiles-daemon iwd)
	for service in "${system_services[@]}"; do
    		echo -e "${GREEN}Enabling & starting $service...${RESET}"
    		sudo systemctl enable --now "$service"
	done

	echo -e "${GREEN}Configuring DNS resolver...${RESET}"
	sudo bash -c \
		"ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf ;\
		cp $HOME/.files/resources/network/* /etc/systemd/network/)"

	echo -e "${GREEN}Enabling user services...${RESET}"
	systemctl --user enable --now obex
	systemctl --user enable --now pipewire.service pipewire.socket
	systemctl --user enable --now wireplumber.service
	systemctl --user enable --now pipewire-pulse.service
fi

# ===========================
# 5️⃣ Pacstall Packages
# ===========================
header "  🛠  Installing Pacstall Packages"
sudo bash -c "$(curl -fsSL https://pacstall.dev/q/install)"
pacstall -I gearlever-git dust-bin neovim-git winetricks-git mcpelauncher-ui-git gscreenshot-git rofi ly-git

# ===========================
# 6️⃣ Python Packages
# ===========================
header "    🐍 Installing Python Packages"
pipx install pywal16 --system-site-packages

# ===========================
# 7️⃣ Post Setup
# ===========================
header "		  🖥  Post Setup"
sudo dpkg-reconfigure locales
sudo systemctl disable getty@tty2.service
sudo systemctl enable ly@tty2.service

# ===========================
# 8️⃣ Apply Theming
# ===========================
header		 "🎨 Applying Themes & Icons"
bash $HOME/.files/resources/scripts/walset/walset.sh --load --verbose
source $HOME/.cache/wal/colors-tty.sh

# ===========================
# 9️⃣ Optimize I/O
# ===========================
header "	 ⚡ Enabling BFQ I/O Scheduler"
echo "bfq" | sudo tee /sys/block/sda/queue/scheduler

# ===========================
# 🎉 Setup Complete
# ===========================
echo -e "${CYAN}${BOLD}✅ Installation complete! Enjoy your setup.${RESET}"

