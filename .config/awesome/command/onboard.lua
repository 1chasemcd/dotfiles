local awful = require("awful")

local onboard = {}

onboard.running = function(callback)
    awful.spawn.easy_async_with_shell("pgrep onboard", function(stdout)
        callback(stdout ~= "")
    end)
end

onboard.visible = function(callback)
    local visible = false

    for _,c in ipairs(client.get()) do
        if c.name == "Onboard" then
            visible = true
        end
    end

    callback(visible)
end

onboard.show = function()
    onboard.visible(function(visible)
        if not visible then
            onboard.running(function(running)
                if running then
                    awful.spawn.with_shell("onboard &")
                else
                    awful.spawn.with_shell("onboard & ; onboard")
                end
            end)
        end
    end)
end

onboard.launch = function()
    onboard.visible(function(visible)
        if not visible then
            onboard.running(function(running)
                if not running then
                    awful.spawn.with_shell("onboard &")
                end
            end)
        end
    end)
end

onboard.quit = function(callback)
    awful.spawn.with_shell("killall onboard")
end

onboard.refresh = function()
    onboard.visible(function(visible)
        if visible then
            awful.spawn.with_shell("killall onboard && onboard & ; onboard")

        else
            onboard.running(function(running)
                if running then
                    awful.spawn.with_shell("killall onboard && onboard &")
                end
            end)
        end
    end)
end

return onboard