local awful = require("awful")
local gears = require("gears")
local beautiful = require("theme")
local wibox = require("wibox")

local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tag_color = function(tag) return beautiful.colors["color"..tag.name] end

local markup = function(tag) return "<span foreground='"..beautiful.taglist_fg_empty.."'>"..tag.name.."</span>" end
local markup_occupied = function(tag) return "<span foreground='"..tag_color(tag).."'>"..tag.name.."</span>" end
local markup_focus = function(tag) return "<b><span foreground='"..tag_color(tag).."'>"..tag.name.."</span></b>" end

local update_tag = function(item, tag, index)
    local textbox = item:get_children_by_id('text_tag')[1]
    local selected_indicator = item:get_children_by_id('selected_indicator')[1]

    if tag.selected then
        selected_indicator.bg = tag_color(tag)
    else
        selected_indicator.bg = beautiful.bg_normal
    end

    if tag.selected then
        textbox.markup = markup_focus(tag)
    else if #tag:clients() > 0 then
        textbox.markup = markup_occupied(tag)
    else
        textbox.markup = markup(tag)
    end
    end
end
 
return function(s)
    return awful.widget.taglist {
        screen = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons, 
        shape_border_color = "#ff0000",
        style = {
            
        },
        widget_template = {
            {
                {
                    forced_height = dpi(3),
                    widget = wibox.container.background
                },
                {
                    { 
                        id = "text_tag",
                        widget = wibox.widget.textbox,
                    },
                    id = "margin",
                    left = dpi(5),
                    right = dpi(5),
                    widget = wibox.container.margin
                },
                {
                    {
                        widget = wibox.container.background
                    },
                    id = "selected_indicator",
                    bg = beautiful.bg_normal,
                    forced_height = dpi(3),
                    widget = wibox.container.background
                },
                layout = wibox.layout.align.vertical
            },

            id     = 'background_role',
            widget = wibox.container.background,
            create_callback = function(item, tag, index, _)
                if index == 9 then
                    item:get_children_by_id("margin")[1].right = dpi(10)
                end

                local tooltip = awful.tooltip {
                    objects = {item},
                    margins = dpi(16),
                    mode = "outside",
                    preferred_positions = {"bottom", "right", "left", "top"},
                    preferred_alignments = {"middle", "front", "back"},
                    timer_function = function() 
                        local output = "Clients:"
            
                        for _,c in ipairs(tag:clients()) do
                            if c == client.focus then
                                output = output.."\n<span color='"..beautiful.colors.color2.."'>  "..c.name.."</span>"
                            elseif c:isvisible() then
                                output = output.."\n<span color='"..beautiful.colors.foreground.."'>  "..c.name.."</span>"
                            else
                                output = output.."\n<span color='"..beautiful.colors.foreground_alt.."'>  "..c.name.."</span>"
                            end
                        end
            
                        if output == "Clients:" then
                            output = "<span color='"..beautiful.colors.foreground_alt.."'>Empty</span>"
                        end
            
                        return output
                    end
                }

                update_tag(item, tag, index)

                item:connect_signal("mouse::enter", function() 
                    item.bg = beautiful.colors.background_alt
                end)
                item:connect_signal("mouse::leave", function() 
                    item.bg = beautiful.colors.background
                end)
            end,
            update_callback = update_tag
        },
    }
end