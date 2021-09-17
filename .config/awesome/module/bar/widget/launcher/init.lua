local wibox =  require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("theme")
local naughty = require("naughty")
local launcher_base = require("module.bar.widget.launcher.base")
local config = require("config")

local launchers = {
    launcher_base {
        markup = "",
        margin_left = dpi(10),
        fg = beautiful.colors.color1,
        forced_width = dpi(16),
        launch = config.terminal,
        identifier = "kitty"
    },
    launcher_base {
        markup = "",
        fg = beautiful.colors.color2,
        forced_width = dpi(19),
        launch = config.browser,
        identifier = "firefox"
    },
    
    launcher_base {
        markup = "﬏",
        fg = beautiful.colors.color3,
        forced_width = dpi(16),
        launch = "code",
        identifier = "code-oss"
    },
    launcher_base {
        markup = "",
        fg = beautiful.colors.color4,
        forced_width = dpi(16),
        launch = "xournalpp",
        identifier = "Xournalpp"
    },
    launcher_base {
        markup = "",
        fg = beautiful.colors.color5,
        forced_width = dpi(14),
        launch = "mirage",
        identifier = "Mirage"
    },
    launcher_base {
        markup = "",
        fg = beautiful.colors.color6,
        forced_width = dpi(16),
        launch = "darktable",
        identifier = "Darktable"
    },
    launcher_base {
        markup = "",
        fg = beautiful.colors.color1,
        forced_width = dpi(14),
        launch = function()
            awful.spawn.with_shell(config.terminal_run_command("btm"))
            awful.spawn.with_shell(config.terminal_run_command("htop"))
        end,
        identifier = function(c)
            if c.name:match("btm") or c.name:match("htop") then
                return true
            else
                return false
            end
        end,
    },

    launcher_base {
        markup = "",
        fg = beautiful.colors.color2,
        forced_width = dpi(16),
        launch = "gcolor3",
        identifier = "Gcolor3",
    },
    launcher_base {
        markup = "",
        fg = beautiful.colors.color3,
        forced_width = dpi(17),
        launch = function()
            awful.spawn(config.browser.." --new-window https://drive.google.com")
        end,
        identifier = function(c)
            if c.name:match("Google Drive") then
                return true
            else
                return false
            end
        end,
    },
    launcher_base {
        markup = "",
        fg = beautiful.colors.color4,
        forced_width = dpi(13),
        launch = function()
            awful.spawn(config.browser.." --new-window https://docs.google.com")
        end,
        identifier = function(c)
            if c.name:match("Google Docs") then
                return true
            else
                return false
            end
        end,
    },
    launcher_base {
        markup = "",
        fg = beautiful.colors.color5,
        forced_width = dpi(12),
        launch = function()
            awful.spawn(config.browser.." --new-window https://www.desmos.com/calculator")
        end,
        identifier = function(c)
            return c.name:match("Desmos")
        end,
    },
    launcher_base {
        markup = "",
        margin_right = dpi(10),
        fg = beautiful.colors.color6,
        forced_width = dpi(16),
        launch = config.terminal_run_command("python"),
        identifier = function(c)
            if c.name:match("python") then
                return true
            else
                return false
            end
        end,
    },
}

local launcher_widgets = {
    layout = wibox.layout.fixed.horizontal
}

for _,launcher in ipairs(launchers) do
    launcher_widgets[#launcher_widgets +1] = launcher.widget
end

return launcher_widgets
