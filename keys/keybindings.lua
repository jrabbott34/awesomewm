-- Keybindings — Super as primary modifier, matching Hyprland/Sway conventions
local awful   = require("awful")
local hotkeys = require("awful.hotkeys_popup")
local gears   = require("gears")
local beautiful = require("beautiful")

local M       = {}
local mod     = "Mod4"   -- Super key
local alt     = "Mod1"
local shift   = "Shift"
local ctrl    = "Control"

-- ── Application launchers ─────────────────────────────────────────────────────
-- Override these strings to match your actual apps
local TERMINAL  = os.getenv("TERMINAL") or "kitty"
local BROWSER   = os.getenv("BROWSER")  or "firefox"
local FILES     = "thunar"
local LAUNCHER  = "rofi -show drun -theme ~/.config/rofi/launcher.rasi"
local RUNNER    = "rofi -show run  -theme ~/.config/rofi/launcher.rasi"
local LOCK      = "swaylock"    -- or your preferred locker
local SCREENSHOT = "grimblast copy area"   -- or scrot / maim

-- ── Global keybinds (work regardless of focused window) ───────────────────────
M.global = gears.table.join(

  -- Help
  awful.key({ mod }, "F1",
    hotkeys.show_help,
    { description = "show keybind help", group = "awesome" }),

  -- Reload / quit
  awful.key({ mod, ctrl }, "r",
    awesome.restart,
    { description = "reload awesome", group = "awesome" }),
  awful.key({ mod, ctrl }, "q",
    awesome.quit,
    { description = "quit awesome",   group = "awesome" }),

  -- ── Focus navigation (vim-style) ──────────────────────────────────────────
  awful.key({ mod }, "h",
    function() awful.client.focus.bydirection("left")  end,
    { description = "focus left",  group = "client" }),
  awful.key({ mod }, "l",
    function() awful.client.focus.bydirection("right") end,
    { description = "focus right", group = "client" }),
  awful.key({ mod }, "j",
    function() awful.client.focus.bydirection("down")  end,
    { description = "focus down",  group = "client" }),
  awful.key({ mod }, "k",
    function() awful.client.focus.bydirection("up")    end,
    { description = "focus up",    group = "client" }),

  -- Arrow-key aliases
  awful.key({ mod }, "Left",
    function() awful.client.focus.bydirection("left")  end,
    { description = "focus left",  group = "client" }),
  awful.key({ mod }, "Right",
    function() awful.client.focus.bydirection("right") end,
    { description = "focus right", group = "client" }),
  awful.key({ mod }, "Down",
    function() awful.client.focus.bydirection("down")  end,
    { description = "focus down",  group = "client" }),
  awful.key({ mod }, "Up",
    function() awful.client.focus.bydirection("up")    end,
    { description = "focus up",    group = "client" }),

  -- Focus cycling
  awful.key({ mod }, "Tab",
    function()
      awful.client.focus.history.previous()
      if client.focus then client.focus:raise() end
    end,
    { description = "focus previous", group = "client" }),

  -- ── Layout swap (vim-style) ───────────────────────────────────────────────
  awful.key({ mod, shift }, "h",
    function() awful.client.swap.bydirection("left")  end,
    { description = "swap left",  group = "client" }),
  awful.key({ mod, shift }, "l",
    function() awful.client.swap.bydirection("right") end,
    { description = "swap right", group = "client" }),
  awful.key({ mod, shift }, "j",
    function() awful.client.swap.bydirection("down")  end,
    { description = "swap down",  group = "client" }),
  awful.key({ mod, shift }, "k",
    function() awful.client.swap.bydirection("up")    end,
    { description = "swap up",    group = "client" }),

  -- ── Resize master ─────────────────────────────────────────────────────────
  awful.key({ mod }, "equal",
    function() awful.tag.incmwfact(0.05)  end,
    { description = "grow master",   group = "layout" }),
  awful.key({ mod }, "minus",
    function() awful.tag.incmwfact(-0.05) end,
    { description = "shrink master", group = "layout" }),

  -- Master count
  awful.key({ mod, shift }, "equal",
    function() awful.tag.incnmaster(1, nil, true)  end,
    { description = "increase master count", group = "layout" }),
  awful.key({ mod, shift }, "minus",
    function() awful.tag.incnmaster(-1, nil, true) end,
    { description = "decrease master count", group = "layout" }),

  -- ── Layout cycling ────────────────────────────────────────────────────────
  awful.key({ mod }, "space",
    function() awful.layout.inc(1)  end,
    { description = "next layout",  group = "layout" }),
  awful.key({ mod, shift }, "space",
    function() awful.layout.inc(-1) end,
    { description = "prev layout",  group = "layout" }),

  -- ── Gaps (dynamic, runtime) ───────────────────────────────────────────────
  awful.key({ mod }, "g",
    function()
      local t = awful.screen.focused().selected_tag
      if t then
        local gap = t.gap or beautiful.useless_gap or 6
        awful.tag.setgap(t, gap > 0 and 0 or beautiful.useless_gap)
      end
    end,
    { description = "toggle gaps", group = "layout" }),

  -- ── Screen focus ──────────────────────────────────────────────────────────
  awful.key({ mod, ctrl }, "j",
    function() awful.screen.focus_relative(1)  end,
    { description = "focus next screen", group = "screen" }),
  awful.key({ mod, ctrl }, "k",
    function() awful.screen.focus_relative(-1) end,
    { description = "focus prev screen", group = "screen" }),

  -- ── Launchers ─────────────────────────────────────────────────────────────
  awful.key({ mod }, "Return",
    function() awful.spawn(TERMINAL) end,
    { description = "terminal", group = "launcher" }),
  awful.key({ mod }, "d",
    function() awful.spawn(LAUNCHER) end,
    { description = "app launcher (rofi)", group = "launcher" }),
  awful.key({ mod, shift }, "d",
    function() awful.spawn(RUNNER) end,
    { description = "run prompt (rofi)", group = "launcher" }),
  awful.key({ mod }, "b",
    function() awful.spawn(BROWSER) end,
    { description = "browser", group = "launcher" }),
  awful.key({ mod }, "e",
    function() awful.spawn(FILES) end,
    { description = "file manager", group = "launcher" }),
  awful.key({ mod }, "l",
    function() awful.spawn(LOCK) end,
    { description = "lock screen", group = "launcher" }),
  awful.key({}, "Print",
    function() awful.spawn(SCREENSHOT) end,
    { description = "screenshot area", group = "launcher" }),

  -- ── Media / volume ────────────────────────────────────────────────────────
  awful.key({}, "XF86AudioRaiseVolume",
    function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%") end,
    { description = "volume up",   group = "media" }),
  awful.key({}, "XF86AudioLowerVolume",
    function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%") end,
    { description = "volume down", group = "media" }),
  awful.key({}, "XF86AudioMute",
    function() awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle") end,
    { description = "mute toggle", group = "media" }),
  awful.key({}, "XF86AudioPlay",
    function() awful.spawn("playerctl play-pause") end,
    { description = "play/pause", group = "media" }),
  awful.key({}, "XF86AudioNext",
    function() awful.spawn("playerctl next") end,
    { description = "next track", group = "media" }),
  awful.key({}, "XF86AudioPrev",
    function() awful.spawn("playerctl previous") end,
    { description = "prev track", group = "media" }),

  -- ── Brightness ────────────────────────────────────────────────────────────
  awful.key({}, "XF86MonBrightnessUp",
    function() awful.spawn("brightnessctl set +5%") end,
    { description = "brightness up", group = "media" }),
  awful.key({}, "XF86MonBrightnessDown",
    function() awful.spawn("brightnessctl set 5%-") end,
    { description = "brightness down", group = "media" })
)

-- ── Tag (workspace) keybinds ──────────────────────────────────────────────────
for i = 1, 9 do
  M.global = gears.table.join(M.global,
    awful.key({ mod }, "#" .. i + 9,
      function()
        local s = awful.screen.focused()
        local t = s.tags[i]
        if t then t:view_only() end
      end,
      { description = "switch to tag " .. i, group = "tag" }),
    awful.key({ mod, shift }, "#" .. i + 9,
      function()
        if client.focus then
          local t = client.focus.screen.tags[i]
          if t then client.focus:move_to_tag(t) end
        end
      end,
      { description = "move client to tag " .. i, group = "tag" }),
    awful.key({ mod, ctrl }, "#" .. i + 9,
      function()
        local s = awful.screen.focused()
        local t = s.tags[i]
        if t then awful.tag.viewtoggle(t) end
      end,
      { description = "toggle tag " .. i, group = "tag" }),
    awful.key({ mod, ctrl, shift }, "#" .. i + 9,
      function()
        if client.focus then
          local t = client.focus.screen.tags[i]
          if t then client.focus:toggle_tag(t) end
        end
      end,
      { description = "toggle client on tag " .. i, group = "tag" })
  )
end

-- ── Client (per-window) keybinds ──────────────────────────────────────────────
M.client = gears.table.join(
  -- Close
  awful.key({ mod }, "q",
    function(c) c:kill() end,
    { description = "close", group = "client" }),
  awful.key({ mod, shift }, "q",
    function(c) c:kill() end,
    { description = "close", group = "client" }),

  -- Toggles
  awful.key({ mod }, "f",
    function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    { description = "toggle fullscreen", group = "client" }),
  awful.key({ mod, shift }, "f",
    awful.client.floating.toggle,
    { description = "toggle floating", group = "client" }),
  awful.key({ mod }, "m",
    function(c)
      c.maximized = not c.maximized
      c:raise()
    end,
    { description = "toggle maximize", group = "client" }),
  awful.key({ mod }, "n",
    function(c) c.minimized = true end,
    { description = "minimize", group = "client" }),

  -- Move to master
  awful.key({ mod }, "Return",
    function(c) c:swap(awful.client.getmaster()) end,
    { description = "move to master", group = "client" }),

  -- Move to screen
  awful.key({ mod, shift }, ".",
    function(c) c:move_to_screen() end,
    { description = "move to next screen", group = "client" }),

  -- Keep on top
  awful.key({ mod }, "t",
    function(c) c.ontop = not c.ontop end,
    { description = "toggle keep-on-top", group = "client" }),

  -- Sticky
  awful.key({ mod, shift }, "t",
    function(c) c.sticky = not c.sticky end,
    { description = "toggle sticky", group = "client" })
)

-- ── Mouse bindings for clients ────────────────────────────────────────────────
M.client_buttons = gears.table.join(
  awful.button({},     1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ mod }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ mod }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)

M.mod = mod  -- export for rc.lua

return M
