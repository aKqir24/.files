-- Autostart configuration using oxwm.autostart

-- Display Resolution and Cursor setup
oxwm.autostart([[
	RESOLUTION_REFRESH="1152x864_60.00"
	CURRENT_DISPLAY="$(xrandr --query | grep "connected primary" | cut -d " " -f1)"
	if [ -n "$CURRENT_DISPLAY" ]; then
		xrandr --newmode "${RESOLUTION_REFRESH}"   81.75  1152 1216 1336 1520  864 867 871 897 -hsync +vsync 2>/dev/null || true
		xrandr --addmode ${CURRENT_DISPLAY} "${RESOLUTION_REFRESH}" 2>/dev/null || true
		xrandr --output ${CURRENT_DISPLAY} --mode "${RESOLUTION_REFRESH}" 2>/dev/null || true
	fi
	xsetroot -cursor_name left_ptr
]])

-- Get matugen colors from wallpapers
oxwm.autostart([[
	WALLPAPER="$(find "$HOME/Pictures/Wallpapers" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) 2>/dev/null | shuf -n 1)"
	if [ -n "$WALLPAPER" ]; then
		matugen --continue-on-error image "$WALLPAPER" --source-color-index 1
		sleep 1 && xwallpaper --zoom "$WALLPAPER" &
	fi
]])

-- Audio and Mic
oxwm.autostart("/usr/bin/pipewire")
oxwm.autostart("/usr/bin/wireplumber")
oxwm.autostart("/usr/bin/pipewire-pulse")

-- Transfer Devices And Partitions
oxwm.autostart("/usr/libexec/gvfsd")
oxwm.autostart("/usr/libexec/gvfs-mtp-volume-monitor")
oxwm.autostart("/usr/libexec/gvfs-udisks2-volume-monitor")

-- Applications
oxwm.autostart("dbus-run-session /usr/libexec/power-profiles-daemon")
oxwm.autostart("dbus-run-session pcmanfm --daemon-mode")
oxwm.autostart("syncthing --no-browser")
oxwm.autostart("alacritty --daemon"):
