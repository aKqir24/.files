#!/bin/bash

dev_depends=(
	'libwayland-dev' 'libpcre2-dev' 'libjson-c-dev'
	'libpango1.0-dev' 'libcairo2-dev' 'libgdk-pixbuf-2.0-dev' 'libdrm-dev' 'libgbm-dev'
	'libinput-dev' 'libseat-dev' 'libxkbcommon-dev' 'libxcb-dri3-dev' 'libxcb-present-dev' 
	'libxcb-res0-dev' 'libxcb-render-util0-dev' 'libxcb-ewmh-dev' 'libxcb-icccm4-dev' 
	'libliftoff-dev' 'libdisplay-info-dev' 'liblcms2-dev' 'libpixman-1-dev')

depends=('cmake' 'scdoc' 'meson' 'pkg-config' 'git' 'wayland-protocols')

prepare() {
	#  Clone SwayFX git (The Window Manager) 
	mkdir -p /tmp/build && cd /tmp/build
	git clone https://github.com/WillPower3309/swayfx.git 
	cd /tmp/build/swayfx
	git checkout 0.5.2
	
	# 2. Setup Subprojects Directory
	mkdir subprojects
	cd subprojects
	
	# 3. Clone SceneFX 0.4.1 (The Rendering FX Library)
	# Note: 0.4.1 is required for wlroots 0.19 support
	git clone https://github.com/wlrfx/scenefx.git
	cd scenefx
	git checkout master
	cd ..
	
	# 4. Clone Wlroots 0.19.0 (The Wayland Compositor Backend)
	git clone https://gitlab.freedesktop.org/wlroots/wlroots.git
	cd wlroots
	git checkout 0.19.0
	
	# Return to source root
	cd ../..
}

build() {
	export PKG_CONFIG_PATH='/usr/lib/wlroots0.19/pkgconfig'
	# Configure the build
	meson setup build/

	# Compile
	ninja -C build/
}

if [ "$(id -u)" -ne 0 ]; then
  echo "Error: run this program as root (use sudo)." >&2
  exit 1
fi

case "$1" in
	"--install")
		sudo apt update && sudo apt install -y ${dev_depends[@]} ${depend[@]}
		prepare && build && sudo ninja -C build/ install # build & Install
		sudo apt autoremove
		;;
	"--uninstall")
		sudo apt update && sudo apt purge -y ${dev_depends[@]} ${depend[@]}
		[[ -d /tmp/build ]] && (prepare && build)
		sudo ninja -C build/ uninstall # build & Install
		;;
	*)
		echo 'Please choose an option --install | --uninstall !!'
esac
