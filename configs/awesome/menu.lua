--|    Launcher widget and a main menu      |--
awesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mainmenu = awful.menu(
    { 
        items = 
        { 
            { "awesome", awesomemenu, beautiful.awesome_icon },
            { "open terminal", terminal }
        }
    }
)

launcher = awful.widget.launcher(
    { 
        image = beautiful.awesome_icon,
        menu = mainmenu 
    }
)

-- Configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Tag layout
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.floating,
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.fair,
        awful.layout.suit.fair.horizontal,
        awful.layout.suit.spiral,
        awful.layout.suit.spiral.dwindle,
        awful.layout.suit.max,
        awful.layout.suit.max.fullscreen,
        awful.layout.suit.magnifier,
        awful.layout.suit.corner.nw,
    })
end)
