-- Basic window management
local launch = os.getenv("HOME") .. "/.files/configs/rofi/launch.sh"
oxwm.key.bind({ modkey }, "E", oxwm.spawn("pcmanfm"))
oxwm.key.bind({ modkey }, "Return", oxwm.spawn_terminal())
oxwm.key.bind({ modkey, "Shift" }, "Slash", oxwm.show_keybinds())
oxwm.key.bind({ modkey }, "D", oxwm.spawn({ "sh", "-c", launch .. " run"  }))
oxwm.key.bind({ modkey }, "R", oxwm.spawn({ "sh", "-c", launch .. " drun" }))
oxwm.key.bind({ "Mod1" }, "Tab", oxwm.spawn({ "sh", "-c", launch .. " window"  }))
oxwm.key.bind({ modkey }, "Print", oxwm.spawn({ "sh", "-c", "gscreenshot -s -n" }))

-- Window state toggles
oxwm.key.bind({ modkey }, "F", oxwm.client.toggle_fullscreen())
oxwm.key.bind({ modkey, "Shift" }, "Space", oxwm.client.toggle_floating())

-- Layout management
oxwm.key.bind({ modkey, "Shift" }, "T", oxwm.layout.set("tiling"))
oxwm.key.bind({ modkey, "Shift" }, "N", oxwm.layout.set("normie"))
oxwm.key.bind({ modkey, "Shift" }, "M", oxwm.layout.set("monocle"))
oxwm.key.bind({ modkey, "Shift" }, "S", oxwm.layout.set("scrolling"))

-- Master area controls
oxwm.key.bind({ modkey }, "minus", oxwm.set_master_factor(-5))
oxwm.key.bind({ modkey }, "equal", oxwm.set_master_factor(5))

-- Gaps and bar toggle
oxwm.key.bind({ modkey }, "A", oxwm.toggle_gaps())
oxwm.key.bind({ modkey }, "B", oxwm.toggle_bar())

-- Window manager controls
oxwm.key.bind({ modkey, "Shift" }, "C", oxwm.restart())
oxwm.key.bind({ modkey, "Shift" }, "R", oxwm.restart())
oxwm.key.bind({ "Control" }, "Q", oxwm.client.kill())
oxwm.key.bind({ modkey, "Shift" }, "E", oxwm.quit())

-- Focus movement
oxwm.key.bind({ modkey }, "Up", oxwm.client.focus_stack(-1))
oxwm.key.bind({ modkey }, "Down", oxwm.client.focus_stack(1))

-- Window movement (J/K + arrow keys)
oxwm.key.bind({ modkey, "Shift" }, "J", oxwm.client.move_stack(1))
oxwm.key.bind({ modkey, "Shift" }, "K", oxwm.client.move_stack(-1))
oxwm.key.bind({ modkey, "Shift" }, "Down", oxwm.client.move_stack(1))
oxwm.key.bind({ modkey, "Shift" }, "Up", oxwm.client.move_stack(-1))

-- Multi-monitor (Comma/Period as well)
oxwm.key.bind({ modkey }, "Comma", oxwm.monitor.focus(-1))
oxwm.key.bind({ modkey }, "Period", oxwm.monitor.focus(1))
oxwm.key.bind({ modkey, "Shift" }, "Comma", oxwm.monitor.tag(-1))
oxwm.key.bind({ modkey, "Shift" }, "Period", oxwm.monitor.tag(1))

-- Workspace navigation
for key=1, 8, 1 do 
	tag=tostring(key - 1)
	key=tostring(key)
	oxwm.key.bind({ modkey }, key, oxwm.tag.view(tag))
	oxwm.key.bind({ modkey, "Shift" }, key, oxwm.tag.move_to(tag))
	oxwm.key.bind({ modkey, "Control" }, key, oxwm.tag.toggleview(tag))
	oxwm.key.bind({ modkey, "Control", "Shift" }, key, oxwm.tag.toggletag(tag))
end
