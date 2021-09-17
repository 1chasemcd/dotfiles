
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

require("awful.autofocus")
require("module.notify")
require("theme")
require("module.layout")
require("module.rules")
require("keys")
require("module.autostart")
require("module.wallpaper")
require("module.bar")
require("module.clientstart")
