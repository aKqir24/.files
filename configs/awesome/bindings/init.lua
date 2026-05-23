modkey = "Mod4" -- Default modkey.

--|     Mouse bindings      |--
awful.mouse.append_global_mousebindings({
    awful.button({ }, 3, function () mainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})

--|     Load The Keys     |--
require("bindings.keys")
require("bindings.signals")
