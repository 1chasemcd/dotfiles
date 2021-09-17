local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("theme")
local widget_base = require("module.bar.widget.base")
local power_menu = require("module.menu.power")

local power = widget_base {
    fg = beautiful.colors.color1,
    timeout = 0,
    
    widget = {
        font = beautiful.font_family.." "..(beautiful.icon_font_size - 1),
        text = "",
        forced_width = dpi(15),
        widget = wibox.widget.textbox
    },

    buttons = gears.table.join(
        awful.button({ }, 1, power_menu.start)
    )
}


return power.widget