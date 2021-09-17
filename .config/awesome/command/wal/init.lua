local awful = require("awful")
local onboard = require("command.onboard")

-- Commands to set theme using pywal and a rofi menu

local wal = {}

wal.set_theme = function()
    awful.spawn.easy_async_with_shell("cat ~/.config/awesome/command/wal/favorites | rofi -dmenu -p 'theme'", function(theme)
        if theme ~= "" then
            if theme:match("add to favorites") then
                awful.spawn.with_shell("echo $(cat ~/.config/awesome/command/wal/current) >> ~/.config/awesome/command/wal/favorites")
            else
                awful.spawn.easy_async_with_shell("wal --theme "..theme, function(stdout)
                    local new_theme = stdout:match("Set theme to [^%s]+1%;37m([^%s]+).json")
                    awful.spawn.with_shell("echo "..new_theme.." > ~/.config/awesome/command/wal/current")

                    -- Recompile sass for custom materia theme
                    -- Also use xsettingsd to immediately update application themes
                    awful.spawn.with_shell("cd ~/.config/materia-theme/_build && sudo meson setup --wipe && sudo meson install ; killall xsettingsd ; xsettingsd")
                    -- Refresh onboard to change theme
                    onboard.refresh()
                    awesome.restart()
                end)
            end
        end
    end)
end

return wal