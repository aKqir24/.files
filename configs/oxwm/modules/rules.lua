-- Floating position for all floating windows/dialogs
oxwm.set_floating_position("center")

-- Window Rules
oxwm.rule.add({ instance = "gimp", floating = true })
oxwm.rule.add({ class = "Pcmanfm", floating = true })
oxwm.rule.add({ instance = "pcmanfm", floating = true })
oxwm.rule.add({ class = "Zenity", floating = true })
oxwm.rule.add({ instance = "zenity", floating = true })
