local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("theme")
local screencapture_menu = require("module.menu.screencapture")
local widget_base = require("module.bar.widget.base")

local recording = false
local start_time = 0
local alt_color = false

screencapture = widget_base {
    fg = beautiful.colors.color2,
    timeout = 1,

    widget = {
        id = "icon",
        markup = "",
        font = beautiful.font_family.." "..beautiful.icon_font_size,
        forced_width = dpi(20),
        widget = wibox.widget.textbox
    },

    update = function(widget)
        awful.spawn.easy_async_with_shell("pgrep ffmpeg", function(stdout)
            if stdout == "" then
                recording = false
                widget:get_children_by_id("icon")[1]:set_markup("")
                widget:get_children_by_id("icon")[1]:set_forced_width(dpi(20))
            else
                recording = true

                if alt_color then
                    widget:get_children_by_id("icon")[1]:set_markup("<span color='"..beautiful.colors.color1.."'></span>")
                else
                    widget:get_children_by_id("icon")[1]:set_markup("")
                end
                widget:get_children_by_id("icon")[1]:set_forced_width(dpi(18))

                alt_color = not alt_color
            end
        end)
    end,

    tooltip_timer_function = function()
        local output = ""
        
        if recording then
            local total_seconds = os.time() - start_time
            local seconds = total_seconds % 60
            local minutes = (total_seconds // 60) % 60

            if seconds < 10 then
                seconds = "0"..seconds
            end

            if minutes < 10 then
                minutes = "0"..minutes
            end
            output = "<span color='"..beautiful.colors.color1.."'></span> Recording - "..minutes..":"..seconds
        else
            output = "No Recordings in Progress"
        end

        return output
    end,

    buttons = gears.table.join(
        awful.button({ }, 1, screencapture_menu.start)
    )
}

awesome.connect_signal("screencapture::start", function()
    start_time = os.time()
end)

return screencapture.widget
