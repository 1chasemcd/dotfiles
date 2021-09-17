local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("theme")
local widget_base = require("module.bar.widget.base")

local restart = widget_base {
    fg = beautiful.colors.color6,
    margin_left = dpi(10),
    timeout = 0,
    
    widget = {
        font = beautiful.font_family.." "..(beautiful.icon_font_size - 2),
        text = "",
        forced_width = dpi(16),
        widget = wibox.widget.textbox
    },

    buttons = gears.table.join(
        awful.button({ }, 1, awesome.restart)
    )
}


return restart.widget