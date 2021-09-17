local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Add hotkeys to help menu for mouse
hotkeys_popup.widget.add_hotkeys(require("keys.help"))

-- Set keys
root.keys(require("keys.global"))