-- Keybindings — ported directly from hyprland.lua
-- Super as primary modifier (matches mainMod = "SUPER")
local awful   = require("awful")
local hotkeys = require("awful.hotkeys_popup")
local gears   = require("gears")

local M       = {}
local mod     = "Mod4"   -- SUPER
local shift   = "Shift"
local ctrl    = "Control"

-- ── Apps — matching hyprland.lua variables ────────────────────────────────────
local TERMINAL  = "alacritty"
local BROWSER   = "firefox"
local FILES     = "thunar"
local LAUNCHER  = "wofi --show drun"
local LOCK      = "hyprlock"         -- swap for an X11 locker if needed (e.g. i3lock)
local LOGOUT    = "wlogout"

-- ── Screenshots — X11 equivalents of grim+slurp+wl-copy ──────────────────────
-- "Print"            → select area, copy to clipboard (like grim -g "$(slurp)" - | wl-copy)
-- "Super+Print"      → full screen, save to ~/Pictures/screenshots/
-- "Super+Shift+Print"→ active monitor, copy to clipboard
local SS_AREA   = "maim -s | xclip -selection clipboard -t image/png && notify-send 'Screenshot' 'Copied to clipboard'"
local SS_SAVE   = "bash -c 'maim ~/Pictures/screenshots/$(date +%Y%m%d-%H%M%S).png && notify-send Screenshot Saved'"
local SS_MON    = "bash -c 'maim -i $(xdotool getactivewindow) | xclip -selection clipboard -t image/png'"

-- ── Global keybinds ───────────────────────────────────────────────────────────
M.global = gears.table.join(

  -- Help popup
  awful.key({ mod }, "F1",
    hotkeys.show_help,
    { description = "show keybind help", group = "awesome" }),

  -- Reload / quit
  awful.key({ mod, ctrl }, "r",
    awesome.restart,
    { description = "reload awesome", group = "awesome" }),
  awful.key({ mod, ctrl }, "q",
    awesome.quit,
    { description = "quit awesome", group = "awesome" }),

  -- ── Focus — arrow keys (primary, matching Hyprland binds) ─────────────────
  awful.key({ mod }, "left",
    function() awful.client.focus.bydirection("left")  end,
    { description = "focus left",  group = "client" }),
  awful.key({ mod }, "right",
    function() awful.client.focus.bydirection("right") end,
    { description = "focus right", group = "client" }),
  awful.key({ mod }, "up",
    function() awful.client.focus.bydirection("up")    end,
    { description = "focus up",    group = "client" }),
  awful.key({ mod }, "down",
    function() awful.client.focus.bydirection("down")  end,
    { description = "focus down",  group = "client" }),

  -- vim aliases (bonus — Awesome doesn't conflict like Hyprland did)
  awful.key({ mod }, "h",
    function() awful.client.focus.bydirection("left")  end,
    { description = "focus left (vim)",  group = "client" }),
  awful.key({ mod }, "k",
    function() awful.client.focus.bydirection("up")    end,
    { description = "focus up (vim)",    group = "client" }),

  -- ── Move windows — SHIFT + arrows ─────────────────────────────────────────
  awful.key({ mod, shift }, "left",
    function() awful.client.swap.bydirection("left")  end,
    { description = "swap left",  group = "client" }),
  awful.key({ mod, shift }, "right",
    function() awful.client.swap.bydirection("right") end,
    { description = "swap right", group = "client" }),
  awful.key({ mod, shift }, "up",
    function() awful.client.swap.bydirection("up")    end,
    { description = "swap up",    group = "client" }),
  awful.key({ mod, shift }, "down",
    function() awful.client.swap.bydirection("down")  end,
    { description = "swap down",  group = "client" }),

  -- ── Resize — CTRL + arrows (repeating in Hyprland → just hold in Awesome) ─
  -- For tiled windows this adjusts master width factor; for floating it resizes directly.
  awful.key({ mod, ctrl }, "right",
    function()
      if client.focus then
        if client.focus.floating then
          client.focus:relative_move(0, 0, 30, 0)
        else
          awful.tag.incmwfact(0.03)
        end
      end
    end,
    { description = "resize right / grow master", group = "client" }),
  awful.key({ mod, ctrl }, "left",
    function()
      if client.focus then
        if client.focus.floating then
          client.focus:relative_move(0, 0, -30, 0)
        else
          awful.tag.incmwfact(-0.03)
        end
      end
    end,
    { description = "resize left / shrink master", group = "client" }),
  awful.key({ mod, ctrl }, "up",
    function()
      if client.focus then
        if client.focus.floating then
          client.focus:relative_move(0, 0, 0, -30)
        else
          awful.tag.incmwfact(-0.03)
        end
      end
    end,
    { description = "resize up", group = "client" }),
  awful.key({ mod, ctrl }, "down",
    function()
      if client.focus then
        if client.focus.floating then
          client.focus:relative_move(0, 0, 0, 30)
        else
          awful.tag.incmwfact(0.03)
        end
      end
    end,
    { description = "resize down", group = "client" }),

  -- Alt-tab style
  awful.key({ mod }, "Tab",
    function()
      awful.client.focus.history.previous()
      if client.focus then client.focus:raise() end
    end,
    { description = "focus previous", group = "client" }),

  -- ── Layout ────────────────────────────────────────────────────────────────
  -- Super+J = togglesplit in Hyprland → cycle layout in Awesome
  awful.key({ mod }, "j",
    function() awful.layout.inc(1) end,
    { description = "next layout (togglesplit equiv)", group = "layout" }),
  awful.key({ mod, shift }, "j",
    function() awful.layout.inc(-1) end,
    { description = "prev layout", group = "layout" }),

  -- Master size
  awful.key({ mod }, "equal",
    function() awful.tag.incmwfact(0.05)  end,
    { description = "grow master",   group = "layout" }),
  awful.key({ mod }, "minus",
    function() awful.tag.incmwfact(-0.05) end,
    { description = "shrink master", group = "layout" }),

  -- ── Launchers — matching hyprland.lua exactly ─────────────────────────────
  -- Super+Return = terminal
  awful.key({ mod }, "Return",
    function() awful.spawn(TERMINAL) end,
    { description = "terminal (alacritty)", group = "launcher" }),
  -- Super+Space = wofi drun (launcher)
  awful.key({ mod }, "space",
    function() awful.spawn(LAUNCHER) end,
    { description = "app launcher (wofi)", group = "launcher" }),
  -- Super+E = file manager
  awful.key({ mod }, "e",
    function() awful.spawn(FILES) end,
    { description = "file manager (thunar)", group = "launcher" }),
  -- Super+B = browser
  awful.key({ mod }, "b",
    function() awful.spawn(BROWSER) end,
    { description = "browser (firefox)", group = "launcher" }),
  -- Super+F = fullscreen (handled per-client below, but also useful globally)

  -- ── Session ───────────────────────────────────────────────────────────────
  -- Super+L = lock (hyprlock → i3lock/swaylock on X11)
  awful.key({ mod }, "l",
    function() awful.spawn(LOCK) end,
    { description = "lock screen", group = "session" }),
  -- Super+Shift+E = logout (wlogout)
  awful.key({ mod, shift }, "e",
    function() awful.spawn(LOGOUT) end,
    { description = "logout (wlogout)", group = "session" }),

  -- ── Screenshots — X11 equivalents of grim/slurp/wl-copy ──────────────────
  awful.key({}, "Print",
    function() awful.spawn.with_shell(SS_AREA) end,
    { description = "screenshot area → clipboard", group = "screenshot" }),
  awful.key({ mod }, "Print",
    function() awful.spawn.with_shell(SS_SAVE) end,
    { description = "screenshot full → save file", group = "screenshot" }),
  awful.key({ mod, shift }, "Print",
    function() awful.spawn.with_shell(SS_MON) end,
    { description = "screenshot monitor → clipboard", group = "screenshot" }),

  -- ── Waybar equiv: toggle wibar visibility ─────────────────────────────────
  -- Super+Shift+B → toggle wibar (Awesome's built-in bar)
  awful.key({ mod, shift }, "b",
    function()
      local s = awful.screen.focused()
      if s.mywibar then s.mywibar.visible = not s.mywibar.visible end
    end,
    { description = "toggle wibar", group = "awesome" }),

  -- ── Wallpaper (random) ────────────────────────────────────────────────────
  -- Super+Shift+W = random wallpaper from ~/Pictures (like waypaper --random)
  awful.key({ mod, shift }, "w",
    function()
      awful.spawn.with_shell(
        "feh --bg-fill --randomize ~/Pictures/ 2>/dev/null || " ..
        "nitrogen --set-zoom-fill --random ~/Pictures/")
    end,
    { description = "random wallpaper", group = "launcher" }),

  -- ── Media / volume (locked = works on lock screen too) ───────────────────
  awful.key({}, "XF86AudioRaiseVolume",
    function() awful.spawn("~/.config/hypr/scripts/volume.sh raise") end,
    { description = "volume up",   group = "media" }),
  awful.key({}, "XF86AudioLowerVolume",
    function() awful.spawn("~/.config/hypr/scripts/volume.sh lower") end,
    { description = "volume down", group = "media" }),
  awful.key({}, "XF86AudioMute",
    function() awful.spawn("~/.config/hypr/scripts/volume.sh mute") end,
    { description = "mute toggle", group = "media" }),
  awful.key({}, "XF86AudioMicMute",
    function() awful.spawn("~/.config/hypr/scripts/volume.sh micmute") end,
    { description = "mic mute", group = "media" }),

  -- ── Brightness ────────────────────────────────────────────────────────────
  awful.key({}, "XF86MonBrightnessUp",
    function() awful.spawn("~/.config/hypr/scripts/brightness.sh raise") end,
    { description = "brightness up", group = "media" }),
  awful.key({}, "XF86MonBrightnessDown",
    function() awful.spawn("~/.config/hypr/scripts/brightness.sh lower") end,
    { description = "brightness down", group = "media" }),

  -- ── Screen focus (multi-monitor) ──────────────────────────────────────────
  awful.key({ mod, ctrl }, "j",
    function() awful.screen.focus_relative(1)  end,
    { description = "focus next screen", group = "screen" }),
  awful.key({ mod, ctrl }, "k",
    function() awful.screen.focus_relative(-1) end,
    { description = "focus prev screen", group = "screen" })
)

-- ── Tag (workspace) keybinds — 1-9, 0=10 matching Hyprland ─────────────────
for i = 1, 10 do
  local key = i % 10  -- 10 maps to "0", matching Hyprland's loop
  M.global = gears.table.join(M.global,
    -- Super+[0-9] → switch to workspace
    awful.key({ mod }, "#" .. key + 9,
      function()
        local s = awful.screen.focused()
        local t = s.tags[i]
        if t then t:view_only() end
      end,
      { description = "switch to tag " .. i, group = "tag" }),
    -- Super+Shift+[0-9] → move window to workspace
    awful.key({ mod, shift }, "#" .. key + 9,
      function()
        if client.focus then
          local t = client.focus.screen.tags[i]
          if t then client.focus:move_to_tag(t) end
        end
      end,
      { description = "move client to tag " .. i, group = "tag" }),
    -- Super+Ctrl+[0-9] → toggle tag visibility
    awful.key({ mod, ctrl }, "#" .. key + 9,
      function()
        local s = awful.screen.focused()
        local t = s.tags[i]
        if t then awful.tag.viewtoggle(t) end
      end,
      { description = "toggle tag " .. i, group = "tag" })
  )
end

-- ── Client (per-window) keybinds ──────────────────────────────────────────────
M.client = gears.table.join(
  -- Super+Q = close (matching Hyprland)
  awful.key({ mod }, "q",
    function(c) c:kill() end,
    { description = "close window", group = "client" }),

  -- Super+F = fullscreen (matching Hyprland)
  awful.key({ mod }, "f",
    function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    { description = "toggle fullscreen", group = "client" }),

  -- Super+V = toggle float (matching Hyprland Super+V float toggle)
  awful.key({ mod }, "v",
    awful.client.floating.toggle,
    { description = "toggle floating", group = "client" }),

  -- Super+M = maximize
  awful.key({ mod }, "m",
    function(c)
      c.maximized = not c.maximized
      c:raise()
    end,
    { description = "toggle maximize", group = "client" }),

  -- Super+N = minimize
  awful.key({ mod }, "n",
    function(c) c.minimized = true end,
    { description = "minimize", group = "client" }),

  -- Move to master
  awful.key({ mod, shift }, "Return",
    function(c) c:swap(awful.client.getmaster()) end,
    { description = "move to master", group = "client" }),

  -- Move to next screen
  awful.key({ mod, shift }, ".",
    function(c) c:move_to_screen() end,
    { description = "move to next screen", group = "client" }),

  -- Keep on top
  awful.key({ mod }, "t",
    function(c) c.ontop = not c.ontop end,
    { description = "toggle keep-on-top", group = "client" }),

  -- Sticky (visible on all tags)
  awful.key({ mod, shift }, "t",
    function(c) c.sticky = not c.sticky end,
    { description = "toggle sticky", group = "client" })
)

-- ── Mouse bindings for clients ────────────────────────────────────────────────
-- Super+LMB = drag window (matching Hyprland mouse:272)
-- Super+RMB = resize window (matching Hyprland mouse:273)
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

-- ── Root (desktop) mouse — scroll workspaces with mouse wheel ─────────────────
-- Matches: Super+mouse_down / mouse_up from Hyprland
M.root_buttons = gears.table.join(
  awful.button({},     3, function()
    -- right-click on desktop opens menu (set in rc.lua)
  end),
  awful.button({ mod }, 4, awful.tag.viewnext),   -- scroll down = next workspace
  awful.button({ mod }, 5, awful.tag.viewprev),   -- scroll up   = prev workspace
  awful.button({},     4, awful.tag.viewnext),    -- also works without mod
  awful.button({},     5, awful.tag.viewprev)
)

M.mod = mod

return M
