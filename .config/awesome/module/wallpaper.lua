local config = require("config")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local icon = require("icon")

local wallpaper = {}

wallpaper.path = icon.convert_template_svg({input = "/home/chasemcdonald/.config/awesome/icon/base/wallpaper.svg", return_type = "path", callback = function(path)
    gears.wallpaper.fit(path)
end})

screen.connect_signal("property::geometry", function(s) gears.wallpaper.fit(wallpaper.path, s) end)

return wallpaper