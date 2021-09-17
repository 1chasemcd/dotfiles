local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("theme")
local widget_base = require("module.bar.widget.base")

local command = "cat /sys/class/power_supply/BAT0/status ; cat /sys/class/power_supply/BAT0/capacity ; cat /sys/class/power_supply/BAT0/charge_now"
local icons = {"", "", "", "", "", "", "", "", "", "", ""}

-- local previous_charge
-- local charge_full
-- local total_charge_change = 0
-- local total_charge_time = 0

local status
local capacity
local charge

-- Initialize charge_full variable
-- awful.spawn.easy_async("cat /sys/class/power_supply/BAT0/charge_full", function(stdout)
--     charge_full = tonumber(stdout)
-- end)

local battery = widget_base {
    fg = beautiful.colors.color3,
    widget = {
        font = beautiful.font_family.." "..beautiful.icon_font_size,
        id = "icon",
        text = "",
        forced_width = dpi(12),
        widget = wibox.widget.textbox
    },

    update = function(widget)
        awful.spawn.easy_async_with_shell("cat /sys/class/power_supply/BAT0/status ; cat /sys/class/power_supply/BAT0/capacity", function(stdout)
            local split_values = {}
            for match in stdout:gmatch("%S+") do
                split_values[#split_values+1] = match
            end
            
            local icon
            if split_values[1] == "Charging" then
                icon = ""
            else
                icon = icons[(split_values[2] + 5) // 10 + 1]
            end

            widget:get_children_by_id("icon")[1]:set_text(icon)
        end)
    end,

    timer_callback = function()
        awful.spawn.easy_async_with_shell("cat /sys/class/power_supply/BAT0/status ; cat /sys/class/power_supply/BAT0/charge_now ; cat /sys/class/power_supply/BAT0/capacity", function(stdout)
            local split_values = {}
            for match in stdout:gmatch("%S+") do
                split_values[#split_values+1] = match
            end

            -- Reset charge trackers when battery status changes
            -- if status ~= split_values[1] then
            --     total_charge_change = 0
            --     total_charge_time = 0
            -- end

            status = split_values[1]
            -- charge = tonumber(split_values[2])
            capacity = tonumber(split_values[3])

            -- if previous_charge then
            --     total_charge_change = total_charge_change + (charge - previous_charge)
            --     total_charge_time = total_charge_time + 3
            -- end
            
            -- previous_charge = charge
        end)
    end,

    tooltip_timer_function = function()
        local output = " "

        if status == "Charging" then
            output = output.."<span color='"..beautiful.colors.color2.."'>Charging </span>"
        else
            output = output.."<span color='"..beautiful.colors.color1.."'>Discharging </span>"
        end

        output = output.."@"

        if capacity <= 10 then
            output = output.."<span color='"..beautiful.colors.color1.."'> "..capacity.."%</span>"
        else if capacity <= 20 then
            output = output.."<span color='"..beautiful.colors.color3.."'> "..capacity.."%</span>"
        else if capacity <= 80 then
            output = output.."<span> "..capacity.."%</span>"
        else
            output = output.."<span color='"..beautiful.colors.color2.."'> "..capacity.."%</span>"
        end end end

        -- local estimate_string
        -- output = output.."\n"
        -- if total_charge_time > 15 then
        --     local estimated_rate = total_charge_change / total_charge_time
        --     local estimated_seconds

        --     if status == 'Charging' then
        --         estimated_seconds = (charge_full - charge) / estimated_rate
        --         local estimated_hours = string.format("%.2f", estimated_seconds / (60.0 * 60.0))
        --         output = output.."~="..estimated_hours.." hrs to <span color='"..beautiful.colors.color2.."'>full</span>"
        --     else
        --         estimated_seconds = charge / -estimated_rate
        --         local estimated_hours = string.format("%.2f", estimated_seconds / (60.0 * 60.0))
        --         output = output.."~="..estimated_hours.." hrs to <span color='"..beautiful.colors.color1.."'>empty</span>"
        --     end

            
        -- else
        --     output = output.."<span color='"..beautiful.colors.foreground_alt.."'>estimating...</span>"
        -- end

        return output
    end
}

return battery.widget