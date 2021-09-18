local awful = require("awful")

return {
    modkey = "Mod4",

    terminal = "alacritty",
    terminal_run_command = function(command) return "alacritty --title='"..command.."' -e zsh -c 'cat ~/.cache/wal/sequences ; "..command.."'" end,
    editor = "vim",
    browser = "firefox",

    home_dir = "/home/chasemcdonald/",
    theme_path = "/home/chasemcdonald/.config/awesome/theme/theme.lua",
    wallpaper_base_path = "/home/chasemcdonald/.config/awesome/module/wallpaper/wallpaper.svg.base",

    layouts = {
        awful.layout.suit.tile,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.spiral,
        awful.layout.suit.fair,
        awful.layout.suit.floating,
        -- awful.layout.suit.tile.left,
        -- awful.layout.suit.tile.top,
        -- awful.layout.suit.fair.horizontal,
        -- awful.layout.suit.spiral.dwindle,
        -- awful.layout.suit.max,
        -- awful.layout.suit.max.fullscreen,
        -- awful.layout.suit.magnifier,
        -- awful.layout.suit.corner.nw,
        -- awful.layout.suit.corner.ne,
        -- awful.layout.suit.corner.sw,
        -- awful.layout.suit.corner.se,
    }
}