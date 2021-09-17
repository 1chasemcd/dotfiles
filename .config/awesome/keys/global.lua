local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local config = require("config")
local audio = require("command.audio")
local screencapture = require("module.menu.screencapture")
local power = require("module.menu.power")
local wal = require("command.wal")
local notify = require("module.notify")


globalkeys = gears.table.join(
	-- Awesome functions
	awful.key({ config.modkey,           }, "h",      hotkeys_popup.show_help,
	          {description="show help", group="awesome"}),
    awful.key({ config.modkey,           }, "r",      awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ config.modkey,           }, "p", power.start,
              {description = "open power menu", group = "awesome"}),
    awful.key({ config.modkey,           }, "u", awful.client.urgent.jumpto,
            {description = "jump to urgent client", group = "client"}),
    awful.key({ config.modkey,           }, "t", function () awful.layout.inc( 1) end,
            {description = "select next layout", group = "awesome"}),
    awful.key({ config.modkey, "Shift"   }, "t", function () awful.layout.inc(-1) end,
            {description = "select previous layout", group = "awesome"}),
    awful.key({ config.modkey,           }, "`", wal.set_theme,
        {description = "randomize color scheme", group = "awesome"}),
    awful.key({ config.modkey, "Shift"   }, "s", screencapture.start,
        {description = "open screencapture menu", group = "awesome"}),




    -- Function keys
    awful.key({                   }, "XF86MonBrightnessDown", function () 
        awful.spawn.easy_async_with_shell("brightnessctl s 5%-", function()
            notify.brightness()
        end) 
    end,
              {description = "reduce backlight", group = "awesome"}),
    awful.key({                   }, "XF86MonBrightnessUp",   function () 
        awful.spawn.easy_async_with_shell("brightnessctl s +5%", function()
            notify.brightness()
        end)
    end,
              {description = "increase backlight", group = "awesome"}),
    awful.key({                   }, "XF86AudioMute", function () 
        audio.set_sink_mute("toggle")
        notify.audio_sink()
    end,
              {description = "toggle audio mute", group = "awesome"}),
    awful.key({                   }, "XF86AudioLowerVolume", function () 
        audio.set_sink_volume("-5%") 
        notify.audio_sink()
    end,
        {description = "reduce audio volume", group = "awesome"}),
    awful.key({                   }, "XF86AudioRaiseVolume",   function () 
        audio.set_sink_volume("+5%") 
        notify.audio_sink()
    end,
              {description = "increase audio volume", group = "awesome"}),
    awful.key({                   }, "#248", function () 
        audio.set_source_mute("toggle")
        notify.audio_source()
    end,
              {description = "toggle microphone mute", group = "awesome"}),

	                  
	-- Program launchers
    awful.key({ config.modkey,           }, "space", function () awful.spawn.with_shell("rofi -show drun") end,
              {description = "open launcher", group = "launcher"}),
              awful.key({ config.modkey,           }, "Tab", function () awful.spawn.with_shell("rofi -show window -theme-str 'window { width: 40%; }'") end,
              {description = "open window switcher", group = "launcher"}),
    awful.key({ config.modkey,           }, "Return", function () awful.spawn(config.terminal) end,
              {description = "open terminal", group = "launcher"}),
    awful.key({ config.modkey,           }, "F1", function () awful.spawn(config.browser) end,
              {description = "open firefox", group = "launcher"}),
    awful.key({ config.modkey,           }, "F2", function () awful.spawn("code") end,
                  {description = "open code", group = "launcher"}),
    awful.key({ config.modkey,           }, "F3", function () awful.spawn("xournalpp") end,
              {description = "open xournalpp", group = "launcher"}),
    
    -- Client keys
    awful.key({ config.modkey, "Shift" }, "m",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
            c:emit_signal(
                "request::activate", "key.unminimize", {raise = true}
            )
            end
        end,
        {description = "restore minimized", group = "client"}),
            
    awful.key({ config.modkey,           }, "Left",
        function ()
            awful.client.focus.global_bydirection("left")
        end,
        {description = "focus left", group = "client"}),
    awful.key({ config.modkey,           }, "Right",
        function ()
            awful.client.focus.global_bydirection("right")
        end,
        {description = "focus right", group = "client"}),
    awful.key({ config.modkey,           }, "Up",
        function ()
            awful.client.focus.global_bydirection("up")
        end,
        {description = "focus up", group = "client"}),
    awful.key({ config.modkey,           }, "Down",
        function ()
            awful.client.focus.global_bydirection("down")
        end,
        {description = "focus down", group = "client"})
)


-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ config.modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ config.modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ config.modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ config.modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

return globalkeys