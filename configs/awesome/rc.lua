--|     If Luarocks is installed      |--
pcall(require, "luarocks.loader")

--|     Standard awesome library       |--
gears = require("gears")
awful = require("awful")
ruled = require("ruled")
wibox = require("wibox")
naughty = require("naughty")
menubar = require("menubar")
beautiful = require("beautiful")
hotkeys_popup = require("awful.hotkeys_popup")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")

--/		Start up Apps		/--
local apps = {
	"fastcompmgr",
	"dbus-run-session pipewire",
	"dbus-run-session wireplumper",
	"dbus-run-session pipewire-pulse",
	"/usr/libexec/gvfsd",
	"/usr/libexec/gvfs-mtp-volume-monitor",
	"/usr/libexec/gvfs-udisks2-volume-monitor",
	"dbus-run-session pcmanfm --daemon-mode"
}

local spawn_shell = ""
for _, app in ipairs(apps) do 
	local bin = app:match("^([^ ]+)")
	spawn_shell = spawn_shell .. string.format("pidof %s > /dev/null || (%s) &\n", bin, app)
end

awful.spawn.with_shell(spawn_shell)

--|      Load all configs       |--
local settings = require("settings")
local menu = require("menu")
local interface = require("interface")
local bindings  = require("bindings.init")

-- awesome_mode: api-level=4:screen=on
