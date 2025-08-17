echo "Please be aware that this install script
is made on a debian mahine, so it might not work on most 
distros not based on debian!" ; sleep 2

# setup dotfiles directory and other dir
git clone https://github.com/aKqir24/.files.git
cd $HOME/.files && stow . --adopt && cd $HOME
git clone https://github.com/aKqir24/pywal16_scripts.git \
	$HOME/.files/resources/scripts/

# Install all base packages
su root -c "apt update ;
apt-get install picom i3-wm pipewire pipewire-pulse \
				wireplumber rofi dunst xinit pipx \
				sudo celluloid alacritty viewnior \
				kdialog yq imagemagick xsettingsd \
				nwg-look stow btop iwd starship \
				pcmanfm systemd-resolved neovim \
				fonts-noto-color-emoji preload \
				fastfetch power-profiles-daemon \
				keepassxc libssl-dev clang gettext \
				libpulse-dev libsensors-dev git \ 
				libpipewire-0.3-dev libtool-bin \
				autoconf automake libnotmuch-dev \
				libtool python3-gi python3-setuptools  

# setup systemd-networkd & services
system_services=( systemd-networkd systemd-resolved iwd 
				  preload power-profiles-daemon )
for service in ${system_service[@]}; do
	systemctl enable --now systemd-networkd
done
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
cp $HOME/.files/resources/network/* /etc/systemd/network/ 
systemctl --user enable --now pipewire.service pipewire.socket
systemctl --user enable --now wireplumber.service
systemctl --user enable --now pipewire-pulse.service"

# pacstall package manager and its available package
sudo $( bash -c "$(curl -fsSL https://pacstall.dev/q/install)" &&
		pacstall -A https://github.com/aKqir24/pacstall-programs/tree/custom-pasctall-pr &&
		pacstall -I carla zen-browser rustdesk-deb i3status-rust rofi-emoji \
		lmms-git )

# install python packages
pipx install pywal16

# build some packages or clone some scripts
git clone https://github.com/thenaterhood/gscreenshot.git
cd gscreenshot && sudo pipx install . rm -r greenshot

# package cleanup
sudo apt autoremove

# Run theming scripts
bash $HOME/.files/resources/scripts/pywal16_scripts/walsetup.sh
bash $HOME/.files/resources/scripts/pywal16_scripts/waloml.sh \
	--alacritty --dunst --i3status-rs=~/.files/.config/i3/status/config.toml
bash $HOME/.files/resources/scripts/pywal16_scripts/theming/rofi.sh
source $HOME/.cache/wal/colors-tty.sh
