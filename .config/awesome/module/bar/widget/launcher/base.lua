local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("theme")
local naughty = require("naughty")

return function(args)
    local base = {}
    
    base.widget = wibox.widget {
        widget = wibox.container.background,
        bg = args.bg or beautiful.bg_normal,
        fg = args.fg or beautiful.fg_normal,
        {
            layout = wibox.layout.align.vertical,
            {
                forced_height = dpi(3),
                widget = wibox.container.background
            },
            {
                layout = wibox.container.margin,
                left = args.margin_left or dpi(6),
                right = args.margin_right or dpi(6),
                top = args.margin_top or dpi(0),
                bottom = args.margin_bottom or dpi(0),
                {
                    markup = args.markup,
                    forced_width = args.forced_width,
                    font = beautiful.font_family.." "..beautiful.icon_font_size,
                    widget = wibox.widget.textbox
                }
            },
            {
                {
                    widget = wibox.container.background,
                    id = "underline",
                    visible = false
                },
                forced_height = dpi(3),
                bg = args.fg or beautiful.fg_normal,
                widget = wibox.container.background
            },
        }
    }

    if type(args.launch) == "string" then
        base.launch = function()
            awful.spawn.with_shell(args.launch)
        end
        base.name = args.launch

    elseif type(args.launch) == "function" then
        base.launch = args.launch
    end

    if type(args.identifier) == "string" then
        base.identifier = function(c)
            return c.class == args.identifier
        end
    elseif type(args.identifier) == "function" then
        base.identifier = args.identifier
    end

    base.widget:connect_signal("mouse::enter", function()
        base.widget.bg = args.bg_hover or beautiful.colors.background_alt
    end)

    base.widget:connect_signal("mouse::leave", function()
        base.widget.bg = args.bg or beautiful.bg_normal
    end)

    base.running = function()
        for _,c in ipairs(client.get()) do
            if base.identifier(c) then
                return true
            end
        end

        return false
    end

    base.tooltip = awful.tooltip {
        objects = {base.widget},
        margins = dpi(16),
        mode = "outside",
        preferred_positions = {"bottom", "right", "left", "top"},
        preferred_alignments = {"middle", "front", "back"},
        timer_function = function() 
            local output = "Running Instances:"

            for c in awful.client.iterate(base.identifier, 1) do
                if c == client.focus then
                    output = output.."\n<span color='"..beautiful.colors.color2.."'>  "..c.name.."</span>"
                elseif c:isvisible() then
                    output = output.."\n<span color='"..beautiful.colors.foreground.."'>  "..c.name.."</span>"
                else
                    output = output.."\n<span color='"..beautiful.colors.foreground_alt.."'>  "..c.name.."</span>"
                end
            end

            if output == "Running Instances:" then
                output = "<span color='"..beautiful.colors.foreground_alt.."'>No Running Instances</span>"
            end

            return output
        end
    }

    gears.timer {
        timeout = 1,
        call_now = true,
        autostart = true,
        callback = function() 
            if base.running() then
                -- naughty.notify({text = "k"})
                base.widget:get_children_by_id("underline")[1].visible = true
            else
                base.widget:get_children_by_id("underline")[1].visible = false
            end
        end
    }

    base.widget:buttons(gears.table.join(
        awful.button({ }, 1, function()
            if base.running() then
                for c in awful.client.iterate(base.identifier) do
                    if c ~= client.focus then
                        c:jump_to()
                        return
                    end
                end
            else
                base.launch()
            end
        end),
        awful.button({ }, 3, base.launch)
    ))

    return base
end