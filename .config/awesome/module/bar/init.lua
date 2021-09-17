local config = require("config")
local wallpaper = require("module.wallpaper")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("theme")
-- local hotkeys_popup = require("awful.hotkeys_popup")

require("module.layout")

local bar = {}

function bar.set_for_screen(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create the wibox
    s.wibox = awful.wibar({ screen = s, bg = "#00000000", height = beautiful.bar_height + beautiful.useless_gap * 2 })

    s.wibox:setup {
        widget = wibox.container.margin, 
        left = beautiful.useless_gap * 2,
        right = beautiful.useless_gap * 2,
        top = beautiful.useless_gap * 2,
        
        {
            layout = wibox.layout.align.horizontal,
            {
                widget = wibox.container.background,
                bg = beautiful.bg_normal,
                shape = gears.shape.rounded_rect,
                radius = beautiful.border_radius,
                shape_clip = true,
                {
                    layout = wibox.layout.fixed.horizontal,
                    require("module.bar.widget.themepicker"),
                    require("module.bar.widget.taglist")(s),
                }
            },
            {
                layout = wibox.layout.align.horizontal,
                expand = "outside",
                nil,
                {
                    widget = wibox.container.background,
                    bg = beautiful.bg_normal,
                    shape = gears.shape.rounded_rect,
                    radius = beautiful.border_radius,
                    shape_clip = true,
                    require("module.bar.widget.launcher")
                },
                nil
            },
            {
                widget = wibox.container.background,
                bg = beautiful.bg_normal,
                shape = gears.shape.rounded_rect,
                radius = beautiful.border_radius,
                shape_clip = true,
                {
                    layout = wibox.layout.fixed.horizontal,
                    require("module.bar.widget.restart"),
                    require("module.bar.widget.power"),
                    require("module.bar.widget.screencapture"),
                    require("module.bar.widget.network"),
                    require("module.bar.widget.bluetooth"),
                    require("module.bar.widget.update"),
                    require("module.bar.widget.audio"),
                    require("module.bar.widget.layoutbox")(s),
                    require("module.bar.widget.battery"),
                    require("module.bar.widget.clock")
                }
            }
        }
    }
end

awful.screen.connect_for_each_screen(
    function(s)
        bar.set_for_screen(s)
    end
)

return bar