#!/bin/bash

# ================================
#	🎨 Debian Dotfiles Installer
# ================================

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
header "             ⚠️  Warning"
echo -e "${YELLOW}Setup: Please be aware that this install script"
echo -e "is made for Debian-based machines and may not work on other distros!${RESET}"
sleep 2

# ===========================
#	1️⃣ Setup dotfiles
# ===========================
header "		  🗂  Dotfiles Setup"
echo -e "${GREEN}Cloning dotfiles repository...${RESET}" && cd "$HOME"
>>>>>>> f10bd1f0 (fix: merge conflict & .stow_ignore)
git clone --recurse-submodules https://github.com/aKqir24/.files.git
echo -e "${GREEN}Applying dotfiles with stow...${RESET}"
cd "$HOME/.files" && stow . --adopt
stow -d resources/global.config/ -t ~ --adopt vscodium
cd "$HOME"

# ===========================
# 2️⃣ Setup MPV thumbfast
# ===========================
header "        🎬 MPV Thumbfast Setup"
mkdir -p "$HOME/.config/mpv/scripts" "$HOME/.config/mpv/script-opts"
wget -P "$HOME/.config/mpv/scripts/" \
    https://raw.githubusercontent.com/po5/thumbfast/refs/heads/master/thumbfast.lua
wget -P "$HOME/.config/mpv/script-opts/" \
    https://raw.githubusercontent.com/po5/thumbfast/refs/heads/master/thumbfast.conf

# ===========================
# 3️⃣ Install Base Packages
# ===========================
header "      📦 Installing Base Packages"
echo -e "${GREEN}Updating apt and installing core packages...${RESET}"
sudo apt update
sudo apt install -y \
pipewire pipewire-pulse libssl-dev wireplumber \
dunst xinit pipx mpv automake sudo alacritty \
viewnior libtool kdialog imagemagick xsettingsd \
nwg-look stow btop starship pcmanfm clang systemd-resolved \
iwd preload git ark gettext fastfetch power-profiles-daemon \
fonts-noto-color-emoji libpulse-dev libsensors-dev libpipewire-0.3-dev \
libtool-bin autoconf libnotmuch-dev yq python3-gi python3-setuptools obexftp \
obexpushd default-jre gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
gstreamer1.0-plugins-bad gstreamer1.0-libav v4l2loopback-dkms obs-studio \
xdg-desktop-portal-wlr xdg-desktop-portal

# ===========================
# 4️⃣ Enable System Services
# ===========================
header "   ⚙️  Configuring Systemd Services"
system_services=(systemd-networkd systemd-resolved power-profiles-daemon iwd)
for service in "${system_services[@]}"; do
    echo -e "${GREEN}Enabling & starting $service...${RESET}"
    sudo systemctl enable --now "$service"
done

echo -e "${GREEN}Configuring DNS resolver...${RESET}"
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sudo cp $HOME/.files/resources/network/* /etc/systemd/network/

echo -e "${GREEN}Enabling user services...${RESET}"
systemctl --user enable --now obex
systemctl --user enable --now pipewire.service pipewire.socket
systemctl --user enable --now wireplumber.service
systemctl --user enable --now pipewire-pulse.service

# ===========================
# 5️⃣ Pacstall Packages
# ===========================
header "  🛠  Installing Pacstall Packages"
sudo bash -c "$(curl -fsSL https://pacstall.dev/q/install)"
pacstall -I gearlever-git i3status-rust rofi-emoji-git bluetuith-bin lmms-git \
	dust-bin neovim-git winetricks-git mcpelauncher-ui-git gscreenshot-git rofi-wayland colorz-git ly-git

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

