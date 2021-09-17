local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
dpi = xresources.apply_dpi

-- Initialize theme
beautiful.init(require("config").theme_path)

return beautiful