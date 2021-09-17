local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("theme")
local naughty = require("naughty")

-- Commands to 

local audio = {}

local command = "pactl info | grep -e 'Default Sink' -e 'Default Source'; pactl list | grep -e 'Name' -e 'Mute' -e 'Volume' ; echo 'sink-inputs below' ; pactl list sink-inputs | grep -e 'application\\.name' -e 'media.name' ; echo 'source-outputs below' ; pactl list source-outputs | grep -e 'application\\.name' -e 'media.name'"

audio.get_info = function(callback)
    awful.spawn.easy_async_with_shell(command, function(stdout, stderr, reason, exitcode)
        local lines = {}
        
        for line in stdout:gmatch("([^\n]+)\n") do
            lines[#lines+1] = line
        end

        local info = {}

        local default_sink_escaped = ""
        local default_source_escaped = ""
        
        for i,line in ipairs(lines) do
            if line:match("Default Sink") then
                info.default_sink = line:sub(15)
                
                default_sink_escaped = info.default_sink:gsub("([^%w])", "%%%1")

            else
                if line:match(default_sink_escaped) and not line:match("monitor") then
                    info.sink_mute = lines[i+1]:match("yes") == "yes"
                    info.sink_volume = tonumber(lines[i+2]:match("/[%s]*([%d]+)%%[%s]*/") or "100")
                end
            end

            if line:match("Default Source") then
                info.default_source = line:sub(17)

                default_source_escaped = info.default_source:gsub("([^%w])", "%%%1")
            else
                if line:match(default_source_escaped) and not line:match("monitor") then
                    info.source_mute = lines[i+1]:match("yes") == "yes"
                    info.source_volume = tonumber(lines[i+2]:match("/[%s]*([%d]+)%%[%s]*/"))
                end
            end
            if line == "sink-inputs below" and lines[i+1] ~= "source-outputs below" then
                info.sink_input_app = lines[i+1]:match('application.name = "([^"]+)"')
                info.sink_input_media = lines[i+2]:match('media.name = "([^"]+)"')
            end

            if line == "source-outputs below" and i ~= #lines then
                info.source_output_app = lines[i+1]:match('application.name = "([^"]+)"')
                info.source_output_media = lines[i+2]:match('media.name = "([^"]+)"')
            end
        end       

        callback(info)
    end)
end

audio.set_sink_volume = function(volume)
    awful.spawn.easy_async_with_shell("pactl set-sink-volume @DEFAULT_SINK@ "..volume, function()
        audio.get_info(function(info)
            if info.sink_volume > 100 then
                awful.spawn.easy_async_with_shell("pactl set-sink-volume @DEFAULT_SINK@ 100%", function()
                    awesome.emit_signal("audio_sink::update")
                end)
            end
        end)

        awesome.emit_signal("audio_sink::update")
    end)
end

audio.set_source_volume = function(volume)
    awful.spawn.easy_async_with_shell("pactl set-source-volume @DEFAULT_SOURCE@ "..volume, function()
        audio.get_info(function(info)
            if info.source_volume > 100 then
                awful.spawn.easy_async_with_shell("pactl set-source-volume @DEFAULT_SOURCE@ 100%", function()
                    awesome.emit_signal("audio:_source:update")
                end)
            end
        end)

        awesome.emit_signal("audio_source::update")
    end)
end

audio.set_sink_mute = function(mute)
    awful.spawn.easy_async_with_shell("pactl set-sink-mute @DEFAULT_SINK@ "..mute, function()
        awesome.emit_signal("audio_sink::update")
    end)
end

audio.set_source_mute = function(mute)
    awful.spawn.easy_async_with_shell("pactl set-source-mute @DEFAULT_SOURCE@ "..mute, function()
        awesome.emit_signal("audio_source::update")
    end)
end

return audio