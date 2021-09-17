local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("theme")
local audio = require("command.audio")

local notify = {}

notify.audio_sink = function()
    audio.get_info(function(info)

        local output

        if info.sink_volume > 100 then
            info.sink_volume = 100
        end
        
        if info.sink_mute then
            output = "Sink: <span color='"..beautiful.colors.color1.."'>Muted</span> @ <span color='"..beautiful.colors.foreground_alt.."'>"..info.sink_volume.."%</span>"
        else
            output = "Sink: <span color='"..beautiful.colors.color2.."'>Unmuted</span> @ "..info.sink_volume.."%"
        end

        naughty.notify({text = output, replaces_id = 1, margin = dpi(16), timeout = 1, border_width = 0})
    end)
end

notify.audio_source = function()
    audio.get_info(function(info)

        local output

        if info.source_volume > 100 then
            info.source_volume = 100
        end
        
        if info.source_mute then
            output = "Source: <span color='"..beautiful.colors.color1.."'>Muted</span> @ <span color='"..beautiful.colors.foreground_alt.."'>"..info.source_volume.."%</span>"
        else
            output = "Source: <span color='"..beautiful.colors.color2.."'>Unmuted</span> @ "..info.source_volume.."%"
        end

        naughty.notify({text = output, replaces_id = 1, margin = dpi(16), timeout = 1, border_width = 0})
    end)
end

notify.brightness = function()
    awful.spawn.easy_async("brightnessctl", function(stdout)
        local percent = stdout:match("%d+%%")
        naughty.notify({text = "Brightness: "..percent, replaces_id = 1, margin = dpi(16), timeout = 1, border_width = 0})
    end)
end

return notify

