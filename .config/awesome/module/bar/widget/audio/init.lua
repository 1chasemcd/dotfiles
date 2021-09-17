local wibox = require("wibox")
local gears = require("gears")
local audio_command = require("command.audio")
local beautiful = require("beautiful")
local audio_sink = require("module.bar.widget.audio.audio_sink")
local audio_source = require("module.bar.widget.audio.audio_source")
local widget_base = require("module.bar.widget.base")

local audio_info = {}

local audio = widget_base {
    margin_left = 0,
    margin_right = 0,
    widget = {
        layout = wibox.layout.fixed.horizontal,
        audio_sink,
        audio_source,
    },

    tooltip_timer_function = function()
        local output = "Sink:\n"
        if audio_info.sink_mute then
            output = output.."<span color='"..beautiful.colors.color1.."'>  Muted</span> @ <span color='"..beautiful.colors.foreground_alt.."'>"..audio_info.sink_volume.."%</span>"
        else
            output = output.."<span color='"..beautiful.colors.color2.."'>  Unmuted</span> @ "..audio_info.sink_volume.."%"
        end

        if audio_info.sink_input_app then
            output = output.."\n  "..audio_info.sink_input_app..": "..audio_info.sink_input_media
        else
            output = output.."\n  No Active Clients"
        end

        local output = output.."\nSource:\n"
        if audio_info.source_mute then
            output = output.."<span color='"..beautiful.colors.color1.."'>  Muted</span> @ <span color='"..beautiful.colors.foreground_alt.."'>"..audio_info.source_volume.."%</span>"
        else
            output = output.."<span color='"..beautiful.colors.color2.."'>  Unmuted</span> @ "..audio_info.source_volume.."%"
        end

        if audio_info.source_output_app then
            output = output.."\n  "..audio_info.source_output_app..": "..audio_info.source_output_media
        else
            output = output.."\n  No Active Clients"
        end

        return output
    end,

    timer_callback = function()
        audio_command.get_info(function(info)
            audio_info = info
        end)
    end
}

return audio.widget