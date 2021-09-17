local wibox =  require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("theme")
local wal = require("command/wal")
local widget_base = require("module.bar.widget.base")

local current_theme = ""

local themepicker = widget_base {
    margin_left = 10,
    widget = {
        text = "",
        font = beautiful.font_family.." "..beautiful.icon_font_size,
        forced_width = dpi(18),
        widget = wibox.widget.textbox
    },

    update = function(widget)
        awful.spawn.easy_async_with_shell("cat ~/.config/awesome/command/wal/current", function(stdout)
            current_theme = stdout:match("([^%s]+)\n")
        end)    
    end,

    tooltip_timer_function = function()
        local output = "Current Theme: "..current_theme

        local num_spaces = (#output - 14) // 2

        output = output.."\n\n"

        for i = 1,num_spaces do
            output = output.." "
        end

        for i = 1,7 do
            output = output.."<span background='"..beautiful.colors["color"..i].."'>  </span>"
        end

        return output

    end,

    buttons = gears.table.join(
        awful.button({ }, 1,  wal.set_theme)
    )
}

return themepicker.widget
