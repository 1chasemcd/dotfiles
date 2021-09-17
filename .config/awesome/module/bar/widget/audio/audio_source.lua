local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("theme")
local audio_command = require("command.audio")
local widget_base = require("module.bar.widget.base")

local audio_source = widget_base {
    fg = beautiful.colors.color1,
    widget = {
        font = beautiful.font_family.." "..beautiful.icon_font_size,
        widget = wibox.widget.textbox,
        id = "icon",
        text = "",
        forced_width = dpi(12)
    },

    update = function(widget)
        audio_command.get_info(function(info)
            local icon
            local forced_width

            if info.source_mute then
                icon = ""
                forced_width = dpi(14)
            else
                icon = ""
                forced_width = dpi(12)
            end

            widget:get_children_by_id("icon")[1]:set_markup("<span>"..icon.."</span>")
            widget:get_children_by_id("icon")[1]:set_forced_width(dpi(forced_width))
        end)
    end,

    buttons = gears.table.join(
        awful.button({ }, 1, function () audio_command.set_source_mute("toggle") end)
    )
}

awesome.connect_signal("audio_source::update", function()
    audio_source.update(audio_source.widget)
end)

return audio_source.widget