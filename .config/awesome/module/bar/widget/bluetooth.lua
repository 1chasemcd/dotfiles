local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("theme")
local widget_base = require("module.bar.widget.base")
local config = require("config")

local command_output
local devices_info = {}

bluetooth = widget_base {
    fg = beautiful.colors.color4,
    widget = {
        id = "icon",
        text = "",
        font = beautiful.font_family.." "..beautiful.icon_font_size,
        forced_width = dpi(12),
        widget = wibox.widget.textbox
    },

    update = function(widget)
        awful.spawn.easy_async_with_shell("bluetoothctl show ; bluetoothctl info", function(stdout)
            command_output = stdout

            -- Start with assumption that bluetooth is on and devices are connected
            local icon = ""
            local forced_width = 15

            if stdout:match("Powered: (%a+)") == "no" then
                -- Off
                icon = ""
                forced_width = 13
            else if stdout:match("Missing device address argument") then
                -- No devices connected, but still powered
                icon = ""
                forced_width = 12
            end end

            widget:get_children_by_id("icon")[1]:set_text(icon)
            widget:get_children_by_id("icon")[1]:set_forced_width(dpi(forced_width))
        end)
    end,

    timer_callback = function()
        awful.spawn.easy_async_with_shell("bluetoothctl devices", function(stdout)
            -- Update info for individual devices - used in tooltip
            for address in stdout:gmatch("Device ([%x:]+)") do
                awful.spawn.easy_async_with_shell("bluetoothctl info "..address, function(stdout2)
                    devices_info[address] = stdout2
                end)
            end
        end)
    end,

    tooltip_timer_function = function()
        local output = ""
        if command_output:match("Powered: (%a+)") == "yes" then
            output = output.."<span color='"..beautiful.colors.color2.."'>Bluetooth On</span>"
        else
            output = output.."<span color='"..beautiful.colors.color1.."'>Bluetooth Off</span>"
        end

        output = output.."\nDevices:"
        
        for _,device in pairs(devices_info) do

            if device:match("Connected: (%a+)") == "yes" then
                output = output.."\n<span color='"..beautiful.colors.color2.."'>  "..device:match("Name: ([%w%p%- ]+)").."</span>"
            else
                output = output.."\n<span color='"..beautiful.colors.foreground_alt.."'>  "..device:match("Name: ([%w%p%- ]+)").."</span>"
            end
            
        end

        return output
    end,

    buttons = gears.table.join(
        awful.button({ }, 1, function () awful.spawn.with_shell(config.terminal_run_command("bluetoothctl")) end),
        awful.button({ }, 3, function () 
            if command_output:match("Powered: (%a+)") == "yes" then
                awful.spawn.with_shell("bluetoothctl power off")
            else
                awful.spawn.with_shell("sudo modprobe -r btusb && sudo modprobe btusb && bluetoothctl power on")
            end
        end)
    )
}


return bluetooth.widget
