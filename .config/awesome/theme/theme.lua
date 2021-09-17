---------------------------
-- Default awesome theme --
---------------------------
local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}
theme.colors = {}

local colors = xresources.get_current_theme()

-- -- Function to shift all components of a color by an integer value
-- -- Useful for creating alternative colors to those in colorscheme
local function color_scale(color_string, scale)
    -- Convert each hexadecimal digit pair string to an integer
    local r = tonumber(color_string:sub(2, 3), 16)
    local g = tonumber(color_string:sub(4,5), 16)
    local b = tonumber(color_string:sub(6,7), 16)

    -- Add shift value, keeping result between 0 and 255
    r = math.floor(math.min(math.max(r * scale, 0), 255))
    g = math.floor(math.min(math.max(g * scale, 0), 255))
    b = math.floor(math.min(math.max(b * scale, 0), 255))

    -- Recreate hexadecimal string
    local result = "#" .. string.format("%x", r) .. string.format("%x", g) .. string.format("%x", b) 

    return result
end

colors.background_alt = color_scale(colors.background, 1.5)
colors.foreground_alt = color_scale(colors.foreground, 0.6)

theme.font_size = 11
theme.icon_font_size = 14
theme.font_family = "CaskaydiaCove Nerd Font"

theme.font          = theme.font_family.." "..theme.font_size

theme.bg_normal     = colors.background
theme.fg_normal     = colors.foreground

theme.bar_height = 32

theme.useless_gap   = dpi(8)
theme.border_width  = dpi(0)
theme.border_radius = dpi(10)

theme.tooltip_bg = theme.bg_normal
theme.tooltip_fg = theme.fg_normal

theme.taglist_fg_empty = colors.foreground_alt
theme.taglist_fg_occupied = colors.foreground
theme.taglist_fg_focus = colors.color1
theme.taglist_fg_urgent = colors.color2

theme.taglist_bg_focus = colors.background

theme.hotkeys_group_margin = theme.useless_gap * 2
theme.hotkeys_modifiers_fg = colors.foreground_alt
theme.hotkeys_font = theme.font_family.." 10"
theme.hotkeys_description_font = theme.font_family.." 10"

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Tela-circle"
theme.colors = colors
return theme



