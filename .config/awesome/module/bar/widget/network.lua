local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("theme")
local widget_base = require("module.bar.widget.base")
local config = require("config")

local command = "nmcli -f TYPE,STATE,CONNECTION -t d"
local command_output = {}

local network = widget_base {
    fg = beautiful.colors.color3,

    widget = {
        id = "icon",
        text = "直",
        font = beautiful.font_family.." "..beautiful.icon_font_size,
        forced_width = 17,
        widget = wibox.widget.textbox
    },

    update = function(widget)
        awful.spawn.easy_async_with_shell(command, function(stdout)
            network_info = {}

            for line in stdout:gmatch("[^\r\n]+") do
                network_info[#network_info+1] = line
            end

            command_output = network_info

            local icon = "睊"
            local forced_width = dpi(17)

            for _,line in ipairs(network_info) do
                
                if line:match("connected") and not line:match("disconnected") then
                    if line:match("wifi") then
                        icon = "直"
                        forced_width = dpi(17)
                    elseif line:match("ethernet") then
                        icon = ""
                        forced_width = dpi(16)
                    end
                end
            end

            widget:get_children_by_id("icon")[1]:set_text(icon)
            widget:get_children_by_id("icon")[1]:set_forced_width(forced_width)
        end)
    end,

    tooltip_timer_function = function()
        local output = "Device   State        Connection"
        for _,line in ipairs(network_info) do
            local type,state,connection = line:match("([^:]+):([^:]+):([^:]*)")
            connection = connection ~= "" and connection or "--"

            local num_spaces1 = ""
            for _ = #type,8 do
                num_spaces1 = num_spaces1.." "
            end

            local num_spaces2 = ""
            for _ = #state,12 do
                num_spaces2 = num_spaces2.." "
            end

            color = (state == "connected" and beautiful.colors.color2) or (state == "disconnected" and beautiful.colors.color1) or beautiful.colors.foreground_alt

            output = output.."\n<span color='"..color.."'>"..type..num_spaces1..state..num_spaces2..connection.."</span>"
        end

        return output
    end,

    buttons = gears.table.join(
        awful.button({ }, 1, function () awful.spawn.with_shell(config.terminal_run_command("nmtui")) end),
        awful.button({ }, 3, function () awful.spawn.with_shell("wifi toggle") end)
    )
}

return network.widget