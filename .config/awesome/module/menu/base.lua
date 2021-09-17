local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("theme")
local naughty = require("naughty")

return function(args)
    local menu = {}
    menu.selected_index = 1
    menu.to_execute = false
    menu.size = #args.entries
    menu.original_root_buttons = root.buttons()


    local entries = {
        layout = args.layout or wibox.layout.fixed.horizontal,
    }

    for i,entry in ipairs(args.entries) do
        entries[#entries + 1] = {
            widget = wibox.container.background,
            id = "bg",
            fg = beautiful.colors["color"..(i % 7)],
            shape = gears.shape.rounded_rect,
            radius = 10,
            {
                widget = wibox.container.margin,
                left = args.margin or dpi(16),
                right = args.margin or dpi(16),
                top = args.margin or 0,
                bottom = args.margin or 0,
                entry
            }
        }
    end

    menu.popup = awful.popup {
        visible = false,
        ontop = true,
        placement = awful.placement.centered,
        widget = {
            widget = wibox.container.margin,
            margins = dpi(16),
            entries
        }
    }

    for i, child in ipairs(menu.popup.widget:get_children_by_id("bg")) do
        child:connect_signal("mouse::enter", function() 
            menu.selected_index = i
            menu.update()
        end)

        child:connect_signal("button::press", function() 
            menu.selected_index = i
            menu.stop(true)
        end)
    end

    menu.update = function()
        for i, child in ipairs(menu.popup.widget:get_children_by_id("bg")) do
            if i == menu.selected_index then
                child.bg = beautiful.colors.background_alt
            else
                child.bg = beautiful.colors.background
            end
        end
    end

    menu.keygrabber = awful.keygrabber {
        keybindings = {
            {{}, 'Right', function()
                if menu.selected_index < menu.size then
                    menu.selected_index = menu.selected_index + 1
                end

                menu.update()
            end},
            {{}, 'Left', function()
                if menu.selected_index > 1 then
                    menu.selected_index = menu.selected_index - 1
                end

                menu.update()
            end},
            {{}, 'Down', function()
                if menu.selected_index < menu.size then
                    menu.selected_index = menu.selected_index + 1
                end

                menu.update()
            end},
            {{}, 'Up', function()
                if menu.selected_index > 1 then
                    menu.selected_index = menu.selected_index - 1
                end

                menu.update()
            end}
        },
        stop_key           = {'Escape', 'Return'},
        stop_event         = 'release',
        start_callback     = function() menu.popup.visible = true end,
        stop_callback      = function(self, stop_key) 
            menu.popup.visible = false 
            client.disconnect_signal("button::press", menu.button_pressed)
            root.buttons(menu.original_root_buttons)
            if menu.to_execute or stop_key == "Return" then
                args.execute(menu.selected_index)
            end
        end,
    }

    menu.start = function()
        menu.keygrabber:start()
        client.connect_signal("button::press", menu.button_pressed)
        root.buttons(gears.table.join(
            awful.button({ }, 1, menu.button_pressed)
        ))
        menu.update()
    end

    menu.button_pressed = function()
        menu.stop()
    end

    menu.stop = function(te)
        menu.to_execute = te or false
        menu.keygrabber:stop()
    end

    return menu
end

