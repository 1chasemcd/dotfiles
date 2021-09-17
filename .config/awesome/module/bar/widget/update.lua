local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("theme")
local widget_base = require("module.bar.widget.base")
local config = require("config")

local command = "zsh -c 'timeout 10 yay -Sy > /dev/null && yay -Qu'"
local command_output = ""

local update = widget_base {
    fg = beautiful.colors.color5,
    timeout = 300,

    widget = {
        {
            id = "update_icon",
            text = "",
            font = beautiful.font_family.." 16",
            forced_width = dpi(21),
            widget = wibox.widget.textbox
        },
        {
            {
                id = "update_text",
                widget = wibox.widget.textbox,
                font = beautiful.font_family.." 7",
                align = "center",
                forced_width = dpi(21)
            },
            layout = wibox.container.margin, 
            top = dpi(3)
        },
        layout = wibox.layout.stack
    },

    update = function(widget)
        awful.spawn.easy_async(command, function(stdout)
            command_output = stdout
            local _,count = stdout:gsub("\n", "")

            if count == 0 then
                widget:get_children_by_id("update_icon")[1]:set_text("")
                widget:get_children_by_id("update_text")[1]:set_markup("")

            else
                widget:get_children_by_id("update_icon")[1]:set_text("")
                widget:get_children_by_id("update_text")[1]:set_markup("<b><span foreground='"..beautiful.bg_normal.."'>"..count.."</span></b>")
            end
        end)
    end,

    tooltip_timer_function = function()
        if not command_output:match("[^%s]") then
            return "System up to date"
        end

        local output = "Updates:"
    
        for line in command_output:gmatch("\n*([^\n]+)\n*") do
            local name, old, new = line:match("([^%s]+) ([%w%.%-%+:]+) %-> ([%w%.%-%+:]+)")
            output = output.."\n  "..name.." <span color='"..beautiful.colors.foreground_alt.."'>"..old.."</span> -> <span color='"..beautiful.colors.color2.."'>"..new.."</span>"
        end
    
        return output
    end,

    buttons = gears.table.join(
        awful.button({ }, 1, function () 
            awesome.emit_signal("update::start")
            awful.spawn.easy_async_with_shell(config.terminal_run_command("yay"), function()
                awesome.emit_signal("update::finish")
            end) 
        end)
    )
}

awesome.connect_signal("update::start", function()
    update.widget:get_children_by_id("update_icon")[1]:set_text("")
    update.widget:get_children_by_id("update_text")[1]:set_markup("<b><span foreground='"..beautiful.bg_normal.."'>...</span></b>")
    update.widget:get_children_by_id("update_text")[1]:set_forced_width(10)
end)

awesome.connect_signal("update::finish", function()
    update.update(update.widget)
end)

return update.widget