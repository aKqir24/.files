modkey = "Mod4"
local terminal = "alacritty"

oxwm.set_terminal(terminal)
oxwm.set_modkey(modkey)
oxwm.set_tags({" ", " ", " ", " ", " ", " ", " ", " "})

colors = require("colors")
require("keybindings")
require("modules.rules")
require("modules.bar")
require("modules.appearance")
require("modules.autostart")
