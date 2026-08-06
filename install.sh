#!/bin/bash

RED="\033[1;31m" GREEN="\033[1;32m" YELLOW="\033[1;33m" CYAN="\033[1;36m" RESET="\033[0m" BOLD="\033[1m"
header() { echo -e "\n${CYAN}==================================================\n ${BOLD}${CYAN}► $1${RESET}\n${CYAN}==================================================${RESET}\n"; }

# 1. Welcome & Compatibility Check
header "1. Welcome & Compatibility Check"
. /etc/os-release
[[ "$ID" =~ ^(debian|devuan|ubuntu)$ || "$ID_LIKE" =~ debian ]] || {
    echo -e "${RED}⚠️  Warning: OS (${ID:-unknown}) may not be fully compatible.${RESET}"
    read -p "Proceed? [y/N] " p; [[ "$p" =~ ^[Yy]$ ]] || exit 1
}
echo -e "${GREEN}✔ Compatible system detected: ${PRETTY_NAME:-$NAME}${RESET}"
sudo -v

# 2. Adding Repos and Utilities
header "2. Adding Repos and Utilities"
sudo mkdir -p /etc/apt/keyrings /etc/apt/sources.list.d
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg >/dev/null
echo "deb [arch=amd64,signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/${VERSION_ID:-12}/prod ${VERSION_CODENAME:-bookworm} main" | sudo tee /etc/apt/sources.list.d/microsoft-prod.list

XLAB_URI="https://xlibre-debian.github.io/$([[ "$ID" = "devuan" || "$ID_LIKE" = "devuan" ]] && echo "devuan" || echo "debian")/"
[ -f /usr/share/keyrings/NexusSfan.pgp ] || sudo wget -O /usr/share/keyrings/NexusSfan.pgp "${XLAB_URI}NexusSfan.pgp" || true
echo "deb [signed-by=/usr/share/keyrings/NexusSfan.pgp] $XLAB_URI stable main" | sudo tee /etc/apt/sources.list.d/xlibre.list

sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
echo "deb [signed-by=/usr/share/keyrings/winehq-archive.key] https://dl.winehq.org/wine-builds/debian/ ${VERSION_CODENAME:-bookworm} main" | sudo tee /etc/apt/sources.list.d/winehq.list

sudo bash -c "$(curl -fsSL https://pacstall.dev/q/install)"

# 3. Installing Packages
header "3. Installing Packages"
sudo apt update && sudo apt install -y $(<"$HOME/.files/apt-packages.txt")
while read -r pkg; do
    [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
    pacstall -I "$pkg" || true
done < "$HOME/.files/pacstall-packages"

# 4. Setting Up Dotfiles
header "4. Setting Up Dotfiles"
[ "$(pwd)" == "${HOME}" ] || cd "${HOME}"
[ -d ".files" ] || git clone --recurse-submodules https://github.com/aKqir24/.files.git
cd ".files" && stow -d configs/ -t "${HOME}"/.config/ --adopt others && cd "$HOME"

curr_sess="${XDG_SESSION_TYPE:-$([[ -n "$WAYLAND_DISPLAY" ]] && echo "wayland" || echo "x11")}"
while true; do
    echo -e "${YELLOW}Choose Window Manager:\n  [1] i3 (X11)\n  [2] xmonad (X11)\n  [3] sway (Wayland)${RESET}"
    read -p "-> " wm_ch
    case "$wm_ch" in
        1) wm="i3"; req="x11" ;;
        2) wm="xmonad"; req="x11" ;;
        3) wm="sway"; req="wayland" ;;
        *) continue ;;
    esac
    [ "$curr_sess" = "$req" ] && break || {
        echo -e "${RED}⚠️  $wm requires $req (current: $curr_sess)!${RESET}"
        read -p "Retry? [Y/n] " r; [[ "$r" =~ ^[Nn]$ ]] && break
    }
done
for w in i3 xmonad sway; do rm -rf "${HOME}/.config/$w"; done
ln -sf "${HOME}/.files/configs/$wm" "${HOME}/.config/"

read -p "Install zen-vscodium? [y/N] " c_zen
if [[ "$c_zen" =~ ^[Yy]$ ]]; then
    mkdir -p "$HOME/.local/share"
    [ -d "$HOME/.local/share/zen-vscodium" ] || git clone https://github.com/aKqir24/zen-vscodium.git "$HOME/.local/share/zen-vscodium"
    stow -d "$HOME/.local/share" -t "$HOME" zen-vscodium || true
fi

read -p "Install PhotoGIMP? [y/N] " c_pg
if [[ "$c_pg" =~ ^[Yy]$ ]]; then
    mkdir -p "$HOME/.local/share/PhotoGIMP"
    wget -qO /tmp/pg.zip https://github.com/Diolinux/PhotoGIMP/releases/download/3.1/PhotoGIMP-linux.zip
    mkdir -p /tmp/pg_ext && unzip -q /tmp/pg.zip -d /tmp/pg_ext
    cp -r /tmp/pg_ext/* "$HOME/.local/share/PhotoGIMP/" 2>/dev/null || cp -r /tmp/pg_ext/. "$HOME/.local/share/PhotoGIMP/"
    rm -rf /tmp/pg.zip /tmp/pg_ext
    stow -d "$HOME/.local/share" -t "$HOME" PhotoGIMP || true
fi

has_mpv=false; has_cel=false
{ command -v mpv &>/dev/null || dpkg -l | grep -q mpv; } && has_mpv=true
{ command -v celluloid &>/dev/null || dpkg -l | grep -q celluloid; } && has_cel=true

if $has_mpv || $has_cel; then
    mkdir -p "$HOME/.local/share/mpv/scripts" "$HOME/.local/share/mpv/script-opts"
    [[ -e "$HOME/.local/share/mpv/scripts/thumbfast.lua" ]] || wget -q -P "$HOME/.local/share/mpv/scripts/" https://raw.githubusercontent.com/po5/thumbfast/refs/heads/master/thumbfast.lua
    [[ -e "$HOME/.local/share/mpv/script-opts/thumbfast.conf" ]] || wget -q -P "$HOME/.local/share/mpv/script-opts/" https://raw.githubusercontent.com/po5/thumbfast/refs/heads/master/thumbfast.conf
    $has_mpv && { mkdir -p "$HOME/.config/mpv"; ln -sfn "$HOME/.local/share/mpv/scripts" "$HOME/.config/mpv/scripts"; ln -sfn "$HOME/.local/share/mpv/script-opts" "$HOME/.config/mpv/script-opts"; }
    $has_cel && { mkdir -p "$HOME/.config/celluloid"; ln -sfn "$HOME/.local/share/mpv/scripts" "$HOME/.config/celluloid/scripts"; ln -sfn "$HOME/.local/share/mpv/script-opts" "$HOME/.config/celluloid/script-opts"; }
fi

# 5. Post Setup
header "5. Post Setup"
if [[ "$(ps -p 1 -o comm=)" == "systemd" ]]; then
    for s in systemd-networkd systemd-resolved power-profiles-daemon iwd; do sudo systemctl enable --now "$s"; done
    sudo bash -c "ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf && cp $HOME/.files/resources/network/* /etc/systemd/network/"
    for s in obex pipewire.service pipewire.socket wireplumber.service pipewire-pulse.service; do systemctl --user enable --now "$s"; done
fi
sudo dpkg-reconfigure locales || true

read -p "Switch to ly display manager (removes other DMs)? [y/N] " c_ly
if [[ "$c_ly" =~ ^[Yy]$ ]]; then
    sudo apt purge -y gdm3 sddm lightdm xdm lxdm || true
    sudo apt install -y ly || pacstall -I ly || true
    sudo systemctl disable display-manager.service getty@tty2.service || true
    sudo systemctl enable ly@tty2.service
fi
echo "bfq" | sudo tee /sys/block/sda/queue/scheduler || true
echo "$USER ALL=(ALL) NOPASSWD: $(which papirus-folders)" | sudo tee /etc/sudoers.d/papirus-folders
sudo chmod 440 /etc/sudoers.d/papirus-folders

# 6. Finalizing
header "6. Finalizing"
source ~/.xprofile
bash "$HOME/.files/resources/scripts/walset/walset.sh" --load --verbose || true
[ -f "$HOME/.cache/wal/colors-tty.sh" ] && source "$HOME/.cache/wal/colors-tty.sh"

# 7. Install Done
header "7. Install Done"
echo -e "${BOLD}${GREEN}✅ Installation complete! Enjoy your setup.${RESET}\n"
