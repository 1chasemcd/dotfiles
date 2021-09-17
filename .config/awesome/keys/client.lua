local gears = require("gears")
local awful = require("awful")
local config = require("config")
local naughty = require("naughty")

local client_key = {}

-- Client keys
client_key.keys = gears.table.join(
	awful.key({ config.modkey,           }, "q",      function (c) c:kill() end,
	          {description = "close window", group = "client"}),
    awful.key({ config.modkey,           }, "m",      function (c) c.minimized = true end,
	          {description = "minimize window", group = "client"}),
    awful.key({ config.modkey,           }, "z",  
        function (c) 
            awful.client.floating.toggle()
            c.above = true
        end                     ,
        {description = "toggle floating", group = "client"}),
    awful.key({ config.modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    
    -- Keys for setting client position
    awful.key({ config.modkey, "Shift"   }, "Left", 
        function (c) 
            if (c.floating or (client.focus and client.focus.first_tag.layout == awful.layout.suit.floating)) 
            then
                local new_geometry = c:geometry()
                new_geometry["x"] = new_geometry["x"] - 40
                c:geometry(new_geometry)
            else
                awful.client.swap.global_bydirection("left")
            end
        end,
        {description = "move window left", group = "layout"}),
    awful.key({ config.modkey, "Shift"   }, "Right", 
        function (c) 
            if (c.floating or (client.focus and client.focus.first_tag.layout == awful.layout.suit.floating)) 
            then
                local new_geometry = c:geometry()
                new_geometry["x"] = new_geometry["x"] + 40
                c:geometry(new_geometry)
            else
                awful.client.swap.global_bydirection("right")
            end
        end,
        {description = "move window right", group = "layout"}),
    awful.key({ config.modkey, "Shift"   }, "Up", 
        function (c) 
            if (c.floating or (client.focus and client.focus.first_tag.layout == awful.layout.suit.floating)) 
            then
                local new_geometry = c:geometry()
                new_geometry["y"] = new_geometry["y"] - 40
                c:geometry(new_geometry)
            else
                awful.client.swap.global_bydirection("up")
            end
        end,
        {description = "move window up", group = "layout"}),
    awful.key({ config.modkey, "Shift"   }, "Down", 
        function (c) 
            if (c.floating or (client.focus and client.focus.first_tag.layout == awful.layout.suit.floating)) 
            then
                local new_geometry = c:geometry()
                new_geometry["y"] = new_geometry["y"] + 40
                c:geometry(new_geometry)
            else
                awful.client.swap.global_bydirection("down")
            end
        end,
        {description = "move window down", group = "layout"}),

    -- Keys for setting client size
    awful.key({ config.modkey, "Control" }, "Left", 
        function (c) 
            if (c.floating or (client.focus and client.focus.first_tag.layout == awful.layout.suit.floating)) 
            then
                local new_geometry = c:geometry()
                new_geometry["width"] = new_geometry["width"] - 40
                c:geometry(new_geometry)
            end

            if (client.focus and client.focus.first_tag.layout == awful.layout.suit.tile)
            then
                awful.tag.incmwfact(-0.0208333333)
            end
        end,
        {description = "decrease window width", group = "layout"}),
    awful.key({ config.modkey, "Control" }, "Right", 
        function (c) 
            if (c.floating or (client.focus and client.focus.first_tag.layout == awful.layout.suit.floating)) 
            then
                local new_geometry = c:geometry()
                new_geometry["width"] = new_geometry["width"] + 40
                c:geometry(new_geometry)
            end

            if (client.focus and client.focus.first_tag.layout == awful.layout.suit.tile)
            then
                awful.tag.incmwfact(0.0208333333)
            end
        end,
        {description = "increase window width", group = "layout"}),
    awful.key({ config.modkey, "Control" }, "Up", 
        function (c) 
            if (c.floating or (client.focus and client.focus.first_tag.layout == awful.layout.suit.floating)) 
            then
                local new_geometry = c:geometry()
                new_geometry["height"] = new_geometry["height"] - 40
                c:geometry(new_geometry)
            end

            if (client.focus and client.focus.first_tag.layout == awful.layout.suit.tile.bottom)
            then
                awful.tag.incmwfact(-0.037037)
            end
        end,
        {description = "decrease window height", group = "layout"}),
    awful.key({ config.modkey, "Control" }, "Down", 
        function (c) 
            if (c.floating or (client.focus and client.focus.first_tag.layout == awful.layout.suit.floating)) 
            then
                local new_geometry = c:geometry()
                new_geometry["height"] = new_geometry["height"] + 40
                c:geometry(new_geometry)
            end

            if (client.focus and client.focus.first_tag.layout == awful.layout.suit.tile.bottom)
            then
                awful.tag.incmwfact(0.037037)
            end
        end,
        {description = "increase window height", group = "layout"})
)

client_key.buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ config.modkey, "Shift" }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ config.modkey, "Control" }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

return client_key