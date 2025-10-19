clear ; echo "setup: Please be aware that this install script
is made on a debian mahine, so it might not work on most 
distros that are not based on debian!" ; sleep 2

# setup dotfiles directory and other dir
echo "setup: Preparing & applying dotfiles"
git clone --recurse-submodules https://github.com/aKqir24/.files.git
cd $HOME/.files && stow . --adopt 
stow -d resources/global.config/ -t ~ --adopt vscodium && cd $HOME

# Setup thumbfast for mpv
wget -P $HOME/.config/mpv/scripts/ \
	https://raw.githubusercontent.com/po5/thumbfast/refs/heads/master/thumbfast.lua
wget -P $HOME/.config/mpv/script-opts/ \
	https://raw.githubusercontent.com/po5/thumbfast/refs/heads/master/thumbfast.conf

# Install all base packages
echo "setup: installing system packages"
su root -c "apt update ;
apt-get install picom i3-wm pipewire pipewire-pulse libssl-dev \
				wireplumber rofi dunst xinit pipx mpv automake \
				sudo alacritty viewnior libtool kdialog imagemagick \
				xsettingsd nwg-look stow btop starship pcmanfm clang \
				systemd-resolved iwd  preload git ark gettext \
				fastfetch power-profiles-daemon fonts-noto-color-emoji \
				libpulse-dev libsensors-dev libpipewire-0.3-dev libtool-bin \
				autoconf libnotmuch-dev yq python3-gi python3-setuptools obexftp \
				obexpushd default-jre gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
                gstreamer1.0-plugins-bad gstreamer1.0-libav

# setup systemd-networkd & services
echo "setup: Configuring system"
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
echo "setup: Installing pacstall & pacstall packages..."
sudo $( bash -c "$(curl -fsSL https://pacstall.dev/q/install)" &&
		pacstall -I carla-git zen-browser i3status-rust rofi-emoji \
		lmms-git dust-bin neovim-git )

echo "setup: Installing base packages"

# install python packages
pipx install pywal16

# build some packages or clone some scripts
git clone https://github.com/thenaterhood/gscreenshot.git
cd gscreenshot && pipx install . && rm -rf greenshot ; sudo apt autoremove

echo "setup: theme & icons are loading..."
# Run theming scripts
bash $HOME/.files/resources/scripts/pywal16_scripts/walsetup.sh --gui --verbose
bash $HOME/.files/resources/scripts/pywal16_scripts/waloml.sh --alacritty \
	--dunst --i3status-rs=~/.files/.config/i3/status/config.toml
bash $HOME/.files/resources/scripts/pywal16_scripts/theming/rofi.sh
source $HOME/.cache/wal/colors-tty.sh

# Turn on BFQ I/O
echo "bfq" | sudo tee /sys/block/sda/queue/scheduler

echo 'setup: Finished!!'
