local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("theme")
local naughty = require("naughty")
local menu = require("module.menu.base")

local function to_nearest_8(value, no_exceed)
    remainder = value % 8

    if remainder >= 4 then
        value = value + (8 - remainder)
    else
        value = value - remainder
    end

    if value > no_exceed then
        value = value - 8
    end

    return value
end

local screencapture =  menu {
    entries = {
        {
            layout = wibox.layout.stack,
            {
                widget = wibox.widget.textbox,
                text = "",
                font = beautiful.font_family.." 72",
                forced_width = 88,
            },
            {
                widget = wibox.container.margin,
                left = 27,
                bottom = 17,
                {
                    widget = wibox.widget.textbox,
                    text = "",
                    font = beautiful.font_family.." 24",
                }
            }

        },
        {
            layout = wibox.layout.stack,
            {
                widget = wibox.container.margin,
                bottom = 13,
                {
                    widget = wibox.widget.textbox,
                    text = "",
                    font = beautiful.font_family.." 82",
                    forced_width = 100
                }
            },
            {
                widget = wibox.container.margin,
                left = 33,
                bottom = 17,
                {
                    widget = wibox.widget.textbox,
                    text = "",
                    font = beautiful.font_family.." 24",
                }
            }
        },
        {
            layout = wibox.layout.stack,
            {
                widget = wibox.widget.textbox,
                text = "",
                font = beautiful.font_family.." 72",
                forced_width = 88
            },
            {
                widget = wibox.container.margin,
                left = 29,
                bottom = 17,
                {
                    widget = wibox.widget.textbox,
                    text = "",
                    font = beautiful.font_family.." 24",
                }
            }

        },
        {
            layout = wibox.layout.stack,
            {
                widget = wibox.container.margin,
                bottom = 13,
                {
                    widget = wibox.widget.textbox,
                    text = "",
                    font = beautiful.font_family.." 82",
                    forced_width = 100
                }
            },
            {
                widget = wibox.container.margin,
                left = 34,
                bottom = 17,
                {
                    widget = wibox.widget.textbox,
                    text = "",
                    font = beautiful.font_family.." 24",
                }
            }
        }
    },

    execute = function(selection)
        if selection == 1 then
            -- Fullscreen Screenshot
            awful.spawn.with_shell("maim --hidecursor | tee $(xdg-user-dir PICTURES)/screenshots/screenshot-$(date +'%Y-%m-%d-%H-%M-%S').png | xclip -selection clipboard -t image/png")
        elseif selection == 2 then
            -- Selection Screenshot
            awful.spawn.easy_async_with_shell("slop -f '%x %y %w %h'", function(stdout)
                if stdout == "" then
                    return
                end

                local x,y,w,h = stdout:match("(%d+) (%d+) (%d+) (%d+)")

                x = tonumber(x)
                y = tonumber(y)
                w = tonumber(w)
                h = tonumber(h)

                awful.spawn.with_shell("maim --hidecursor -g "..w.."x"..h.."+"..x.."+"..y.." | tee $(xdg-user-dir PICTURES)/screenshots/screenshot-$(date +'%Y-%m-%d-%H-%M-%S').png | xclip -selection clipboard -t image/png")
            end)

        elseif selection == 3 then
            -- Fullscreen Capture
            awesome.emit_signal("screencapture::start")
            awful.spawn.with_shell("ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -i :0.0 -f pulse -i default $(xdg-user-dir VIDEOS)/screenrecordings/screenrecording-$(date +'%Y-%m-%d-%H-%M-%S').mp4")
        elseif selection == 4 then
            -- Selection Capture
            awesome.emit_signal("screencapture::start")
            awful.spawn.easy_async_with_shell("slop -f '%x %y %w %h'", function(stdout)
                if stdout == "" then
                    return
                end

                local x,y,w,h = stdout:match("(%d+) (%d+) (%d+) (%d+)")

                x = tonumber(x)
                y = tonumber(y)
                w = tonumber(w)
                h = tonumber(h)

                w = to_nearest_8(w, 1920 - x)
                h = to_nearest_8(h, 1080 - y)


                awful.spawn.with_shell("ffmpeg -video_size "..w.."x"..h.." -framerate 30 -f x11grab -i :0.0+"..x..","..y.." -f pulse -i default $(xdg-user-dir VIDEOS)/screenrecordings/screenrecording-$(date +'%Y-%m-%d-%H-%M-%S').mp4")
            end)
        end
    end
}

screencapture.start_old = screencapture.start

screencapture.start = function()
    awful.spawn.easy_async("pgrep ffmpeg", function(stdout)
        if stdout ~= "" then
            awful.spawn.with_shell("killall -INT ffmpeg")
        else
            screencapture.start_old()
        end
    end)
end

return screencapture