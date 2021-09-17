local awful = require("awful")
local gears = require("gears")
local beautiful = require("theme")
local naughty = require("naughty")

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- set_inner_border_radius(c)

    if not awesome.startup then awful.client.setslave(c) end
 
    if awesome.startup
           and not c.size_hints.user_position
           and not c.size_hints.program_position then
       -- Prevent clients from being unreachable after screen count changes.
       awful.placement.no_offscreen(c)
    end
 end)

--  client.connect_signal("property::width", set_inner_border_radius)
--  client.connect_signal("property::height", set_inner_border_radius)
 
 -- Enable sloppy focus, so that focus follows mouse.
 client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
 end)

client.connect_signal("unfocus", function(c) 
    if c.class == "floating-menu" then
        c:kill()
    end
end)
 
