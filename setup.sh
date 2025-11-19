clear ; echo "setup: Please be aware that this install script
is made on a debian mahine, so it might not work on most 
distros that are not based on debian!" ; sleep 2

# setup dotfiles directory and other dir
echo "setup: Preparing & applying dotfiles"
git clone --recurse-submodules https://github.com/aKqir24/.files.git
cd "$HOME/.files" && stow . --adopt 
stow -d resources/global.config/ -t ~ --adopt vscodium && cd "$HOME"

# Setup thumbfast for mpv
wget -P "$HOME/.config/mpv/scripts/" \
	https://raw.githubusercontent.com/po5/thumbfast/refs/heads/master/thumbfast.lua
wget -P "$HOME/.config/mpv/script-opts/" \
	https://raw.githubusercontent.com/po5/thumbfast/refs/heads/master/thumbfast.conf

# Install all base packages
su root -c "apt update ;\
apt-get install pipewire pipewire-pulse libssl-dev wireplumber \
				dunst xinit pipx celluloid automake sudo alacritty \
				viewnior libtool kdialog imagemagick xsettingsd \ 
				nwg-look stow btop starship pcmanfm clang systemd-resolved \
				iwd  preload git ark gettext fastfetch power-profiles-daemon \
				fonts-noto-color-emoji libpulse-dev libsensors-dev libpipewire-0.3-dev \
				libtool-bin autoconf libnotmuch-dev yq python3-gi python3-setuptools obexftp \
				obexpushd default-jre gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
                gstreamer1.0-plugins-bad gstreamer1.0-libav v4l2loopback-dkms obs-studio \
				xdg-desktop-portal-wlr xdg-desktop-portal

# setup systemd-networkd & services
system_services=( systemd-networkd systemd-resolved
				  power-profiles-daemon iwd )
for service in ${system_service[@]}; do
	systemctl enable --now $service
done
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
cp $HOME/.files/resources/network/* /etc/systemd/network/
systemctl --user enable --now obex
systemctl --user enable --now pipewire.service pipewire.socket
systemctl --user enable --now wireplumber.service
systemctl --user enable --now pipewire-pulse.service"

# pacstall package manager and its available package
sudo $( bash -c "$(curl -fsSL https://raw.githubusercontent.com/aKqir24/pacstall/refs/heads/master/install.sh)" &&
		pacstall -I gearlever-git zen-browser i3status-rust rofi-emoji bluetuith-bin lmms-git dust-bin neovim-git \
		winetricks-git mcpelauncher-ui-git gscreenshot-git carla-git yabridge rofi colorz-git ly-git )

# installing other packages
pipx install pywal16 --system-site-packages

# Post setup
sudo dpkg-reconfigure locales ; \
	systemctl disable getty@tty2.services
	systemctl enable ly@tty2.service

# Run theming/icon scripts
bash $HOME/.files/resources/scripts/walset/walset.sh --load --verbose
source $HOME/.cache/wal/colors-tty.sh

# Finilaize by Turning on BFQ I/O
echo "bfq" | sudo tee /sys/block/sda/queue/scheduler
