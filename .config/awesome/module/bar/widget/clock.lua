local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("theme")
local widget_base = require("module.bar.widget.base")

local clock = widget_base {
    fg = beautiful.colors.color4,
    margin_right = dpi(10),
    timeout = 0,
    
    widget = {
        {
            font = beautiful.font_family.." "..beautiful.icon_font_size,
            text = "",
            forced_width = dpi(16),
            widget = wibox.widget.textbox
        },
        {
            format = "<span>%B %-d, %-I:%M</span>",
            widget = wibox.widget.textclock
        },
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(5)
    }
}


return clock.widget