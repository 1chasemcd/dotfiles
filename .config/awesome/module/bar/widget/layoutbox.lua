local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("theme")
local icon = require("icon")
local widget_base = require("module.bar.widget.base")
local config = require("config")

local icon_base_path = config.home_dir..".config/awesome/icon/base/"

local images = {
    tile = icon.convert_template_svg({input = icon_base_path.."layout_tile.svg", return_type = "widget"}),
    tilebottom = icon.convert_template_svg({input = icon_base_path.."layout_tilebottom.svg", return_type = "widget"}),
    fairv = icon.convert_template_svg({input = icon_base_path.."layout_fairv.svg", return_type = "widget"}),
    spiral = icon.convert_template_svg({input = icon_base_path.."layout_spiral.svg", return_type = "widget"}),
    floating = icon.convert_template_svg({input = icon_base_path.."layout_floating.svg", return_type = "widget"})
}

return function(s)
    local layoutbox = widget_base {
        timeout = 0,
        widget = {
            images.tile,
            id = "image_parent",
            top = dpi(8),
            bottom = dpi(8),
            layout = wibox.container.margin
        },
    
        update = function(widget)
            local l = s.selected_tag.layout.name
            local i

            if l == "tile" then
                i = images.tile
            elseif l == "tilebottom" then
                i = images.tilebottom
            elseif l == "spiral" then
                i = images.spiral
            elseif l == "fairv" then
                i = images.fairv
            elseif l == "floating" then
                i = images.floating
            end

            widget:get_children_by_id("image_parent")[1]:set_children({i, id = "image_parent", top = 8, bottom = 8, layout = wibox.container.margin})
        end,

        tooltip_timer_function = function()
            local output = "Layouts:"

            for _,layout in ipairs(s.selected_tag.layouts) do
                if layout.name == s.selected_tag.layout.name then
                    output = output.."\n<span color='"..beautiful.colors.color2.."'>  "..layout.name.."</span>"
                else
                    output = output.."\n<span color='"..beautiful.colors.foreground_alt.."'>  "..layout.name.."</span>"
                end
            end
            return output
        end,

        buttons = gears.table.join(
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc( 1) end),
            awful.button({ }, 5, function () awful.layout.inc(-1) end)
        )
    }

    for _,tag in ipairs(s.tags) do
        tag:connect_signal("property::layout", function() layoutbox.update(layoutbox.widget) end)
    end

    s:connect_signal("tag::history::update", function() layoutbox.update(layoutbox.widget) end)

    return layoutbox.widget
end