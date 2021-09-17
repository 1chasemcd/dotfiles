local awful = require("awful")
local config = require("config")
local gears = require("gears")
local naughty = require("naughty")
local icon = require("icon")
local onboard = require("command.onboard")

-- autostart
awful.spawn.easy_async_with_shell("killall picom", function()
    awful.spawn.with_shell("picom -b")
end)

awful.spawn.easy_async_with_shell("killall touchegg", function()
    awful.spawn.with_shell("touchegg")
end)

awful.spawn.easy_async_with_shell("killall light-locker", function()
    awful.spawn.with_shell("light-locker")
end)

awful.spawn. easy_async_with_shell("killall xautolock", function()
    -- xss-lock causes hibernate after 5 minutes
    awful.spawn.with_shell("xautolock -time 10 -locker 'sudo systemctl hibernate'")
end)


gears.timer {
    timeout = 1,
    callnow = true,
    autostart = true,
    callback = function()
        awful.spawn.easy_async("cat /proc/acpi/button/lid/LID0/state", function(stdout)
            if stdout:match("closed") then
                awful.spawn("light-locker-command -l")
            end
        end)
    end
}

awesome.connect_signal("startup", function() 
    onboard.refresh()
end)

-- Quit onboard if keyboard input is detected
awful.spawn.with_line_callback("xinput test-xi2 --root 'AT Translated Set 2 keyboard'", {
    stdout = function(line)
        onboard.quit()
    end
})

awful.spawn.with_shell("pactl set-default-source alsa_input.pci-0000_04_00.6.HiFi__hw_acp__source")

-- restart audio server -- weird errors abound!
awful.spawn.with_shell("systemctl restart --user pipewire.service")
