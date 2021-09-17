local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("theme")

return function(args)
    local base = {}
    
    base.widget = wibox.widget {
        widget = wibox.container.background,
        bg = args.bg or beautiful.bg_normal,
        fg = args.fg or beautiful.fg_normal,
        {
            layout = wibox.container.margin,
            left = args.margin_left or dpi(6),
            right = args.margin_right or dpi(6),
            top = args.margin_top or dpi(0),
            bottom = args.margin_top or dpi(0),
            args.widget
        }
    }

    base.update = args.update

    if args.tooltip_timer_function then
        base.tooltip = awful.tooltip {
            objects = {base.widget},
            margins = dpi(16),
            mode = "outside",
            preferred_positions = {"bottom", "right", "left", "top"},
            preferred_alignments = {"middle", "front", "back"},
            timer_function = args.tooltip_timer_function or function() end
        }
    end

    if args.buttons then
        base.widget:buttons(args.buttons)
    end

    if args.timeout ~= 0 then
        gears.timer {
            timeout = args.timeout or 3,
            call_now = true,
            autostart = true,
            callback = function() 
                if args.timer_callback then args.timer_callback() end
                if base.update then base.update(base.widget) end
            end
        }

    end

    base.widget:connect_signal("mouse::enter", function()
        base.widget.bg = args.bg_hover or beautiful.colors.background_alt
    end)

    base.widget:connect_signal("mouse::leave", function()
        base.widget.bg = args.bg or beautiful.bg_normal
    end)

    return base
end