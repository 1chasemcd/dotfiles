local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("theme")
local audio_command = require("command.audio")
local widget_base = require("module.bar.widget.base")


local audio_sink = widget_base {
    fg = beautiful.colors.color6,
    widget = {
        font = beautiful.font_family.." "..beautiful.icon_font_size,
        text = "墳",
        id = "icon",
        forced_width = dpi(15),
        widget = wibox.widget.textbox
    },

    update = function(widget)
        audio_command.get_info(function(info)
            local icon
            local forced_width

            if info.sink_mute then
                icon = "婢"
                forced_width = dpi(15)
            else if info.sink_volume == 0 then
                icon = "奄"
                forced_width = dpi(12)
            else if info.sink_volume < 50 then
                icon = "奔"
                forced_width = dpi(12)
            else
                icon = "墳"
                forced_width = dpi(15)
            end end end

            widget:get_children_by_id("icon")[1]:set_markup("<span>"..icon.."</span>")
            widget:get_children_by_id("icon")[1]:set_forced_width(dpi(forced_width))
        end)
    end,

    buttons = gears.table.join(
        awful.button({ }, 1, function () audio_command.set_sink_mute("toggle") end)
    )
}

awesome.connect_signal("audio_sink::update", function()
    audio_sink.update(audio_sink.widget)
end)

return audio_sink.widget