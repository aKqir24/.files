local status = os.getenv("HOME") .. "/.config/oxwm/status.sh"

local blocks = {
	oxwm.bar.block.static({
		text = "▌",
		interval = 999999999,
		color = colors.light_blue,
		underline = false,
	}),
    -- bluetooth
    oxwm.bar.block.shell({
		format="{} ",
        command = status .. " bt",
        interval = 15,
        color = colors.cyan,
        underline = false,
        click = status .. " toggle_widget bluetooth",
    }),
    -- wifi
    oxwm.bar.block.shell({
		format="{} ",
		command = status .. " wifi",
        interval = 10,
        color = colors.green,
        underline = false,
		click = status .. " toggle_widget wifi",
    }),
    -- net ip
    oxwm.bar.block.shell({
		format="{} ",
        command = status .. " net",
        interval = 10,
        color = colors.cyan,
        underline = false,
    }),
	oxwm.bar.block.static({
		text = "▌",
		interval = 999999999,
		color = colors.light_blue,
		underline = false,
	}),

    -- leftmost: cpu
    oxwm.bar.block.shell({
		format=" {} ",
        command = status .. " cpu",
        interval = 5,
        color = colors.cyan,
        underline = true,
    }),
    -- memory
    oxwm.bar.block.shell({
		format=" {} ",
        command = status .. " mem",
        interval = 5,
        color = colors.red,
        underline = true,
    }),
    -- sound volume
    oxwm.bar.block.shell({
		format=" {} ",
        command = status .. " sound",
        interval = 2,
        color = colors.magenta,
        underline = true,
        click = status .. " volume_step",
    }),
    -- datetime
		oxwm.bar.block.datetime({
	    format = " 󰥔 {} ",
	    date_format = "%I:%M %p",  -- strftime format
		interval = 40,
        color = colors.red,
	    underline = true,
		click = status .. " toggle_widget calendar",
	}),
    -- monitor
    oxwm.bar.block.shell({
		format=" {} ",
        command = status .. " monitor",
        interval = 5,
        color = colors.green,
        underline = false,
        click = status .. " toggle_monitor",
    }),
    -- rightmost: power menu icon
    oxwm.bar.block.static({
        text = "  ",
        interval = 60,
        color = colors.yellow,
        underline = false,
		click = status .. " toggle_widget powermenu",
    }),
}

oxwm.bar.set_font("Hurmit Nerd Font:Bold:size=10")
oxwm.bar.set_blocks(blocks)

-- Tags / bar backgrounds matching the i3status-rust palette
oxwm.bar.set_scheme_normal(colors.white, colors.gray)
oxwm.bar.set_scheme_occupied(colors.light_yellow, colors.gray)
oxwm.bar.set_scheme_selected(colors.light_green, colors.green, colors.gray)
oxwm.bar.set_scheme_urgent(colors.light_red, colors.gray)
