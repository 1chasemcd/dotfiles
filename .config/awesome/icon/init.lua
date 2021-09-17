local config = require("config")
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

local icon = {}

icon.convert_template_svg = function(args)
    local input = args.input or config.home_dir..".config/awesome/icon/base/input.svg"
    local output = args.output or config.home_dir..".config/awesome/icon/output/"..input:gsub("/", "_"):gsub("~", "home")..".png"

    local image_widget = wibox.widget.imagebox("")

    awful.spawn.easy_async_with_shell("~/.config/awesome/icon/convert_template_svg.py "..input.." "..output, function()
        image_widget:set_image(output)

        if args.callback then
            args.callback(output)
        end
    end)

    if args.return_type == "path" then
        return output
    elseif args.return_type == "widget" then
        return image_widget
    end
end

return icon