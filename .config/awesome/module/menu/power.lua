local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("theme")
local naughty = require("naughty")
local menu = require("module.menu.base")

local power = menu {
    entries = {
        {
            widget = wibox.widget.textbox,
            text = "",
            font = beautiful.font_family.." 72",
            forced_width = 62,
        },
        {
            widget = wibox.container.margin,
            top = 6,
            {    
                widget = wibox.widget.textbox,
                text = "",
                font = beautiful.font_family.." 72",
                forced_width = 82,
            }
        },
        {
            widget = wibox.container.margin,
            bottom = 4,
            {
                widget = wibox.widget.textbox,
                forced_height = 10,
                text = "",
                font = beautiful.font_family.." 110",
                forced_width = 86,
            }
        },
        {
            widget = wibox.widget.textbox,
            text = "",
            font = beautiful.font_family.." 72",
            forced_width = 83,
        },
    },

    execute = function(selection)
        if selection == 1 then
            awful.spawn("light-locker-command -l")
        elseif selection == 2 then
            awful.spawn("systemctl hibernate")
        elseif selection == 3 then
            awful.spawn("reboot")
        elseif selection == 4 then
            awful.spawn("poweroff")
        end
    end
}

return power