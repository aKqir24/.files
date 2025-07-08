echo "Please be aware that this install script
is made on a debian mahine, so it might not work on most 
not debian based distro!" ; sleep 2

# Install all base packages
packages=( picom i3wm pipewire pipewire-pulse
		   wireplumber rofi dunst xinit pipx
           sudo celluloid alacritty viewnior
		   kdialog yq imagemagick xsettingsd
           nwg-look stow btop iwd startship
           pcmanfm systemd-resolved neovim 
		   fonts-noto-color-emoji preload 
		   fastfetch power-profiles-daemon )
su root
apt update
for package in ${packages[@]}; do
	apt-get install $package
done
su $USER

# setup dotfiles directory and other dir
stow . --adopt ; cd $HOME

# pacstall package manager and its available package
sudo bash -c "$(curl -fsSL https://pacstall.dev/q/install)"
sudo pacstall -I zen-browser

# install python packages
pipx install pywal16
pipx install pywalfox --system-site-packages

# setup systemd-networkd & services
system_services=( systemd-networkd systemd-resolved iwd 
				  preload power-profiles-daemon )
for service in ${system_service[@]}; do
	sudo systemctl enable --now systemd-networkd
done
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sudo cp $HOME/.files/resources/network/* /etc/systemd/network/ 
systemctl --user enable --now pipewire.service pipewire.socket
systemctl --user enable --now wireplumber.service
systemctl --user enable --now pipewire-pulse.service

# build some packages or clone some scripts
git clone https://github.com/aKqir24/pywal16_scripts.git \
	$HOME/.files/resources/scripts/
sudo apt update && sudo apt install -y \
  rustc cargo gcc libssl-dev libsensors-dev libpulse-dev \
  libnotmuch-dev libpipewire-0.3-dev clang rofi-dev \
  autoconf automake libtool-bin libtool python3-gi \
  python3-setuptools gettext
git clone https://github.com/greshake/i3status-rust
cd i3status-rust ; cargo install --path . --locked
./install.sh ; cd $HOME
curl -LO https://github.com/Mange/rofi-emoji/archive/refs/tags/v3.5.0.zip
unzip v3.5.0.zip ; cd rofi-emoji-3.5.0
autoreconf -i ; mkdir build
cd build/
../configure
make ; sudo make install ; cd $HOME
git clone https://github.com/thenaterhood/gscreenshot.git
cd gscreenshot ; sudo pipx install . --system-site-packages

# source & package cleanup
sudo rm -r ~/i3status-rust
sudo rm -r ~/rofi-emoji-3.5.0
sudo apt au

# Run theming scripts
bash $HOME/.files/resources/scripts/pywal16_scripts/walsetup.sh
bash $HOME/.files/resources/scripts/pywal16_scripts/waloml.sh \
	--alacritty --dunst \
	--i3status-rs=~/.files/.config/i3/status/config.toml
bash $HOME/.files/resources/scripts/pywal16_scripts/theming/rofi.sh
source $HOME/.cache/wal/colors-tty.sh
