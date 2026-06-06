-- AwesomeWM rc.lua — Catppuccin Mocha, modular, Hyprland/Sway parity
-- Requires: awesome-git or >=4.3, vicious, lain (AUR), rofi, picom
pcall(require, "luarocks.loader")

-- ── Core libraries ────────────────────────────────────────────────────────────
local gears   = require("gears")
local awful   = require("awful")
              require("awful.autofocus")
local wibox   = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys = require("awful.hotkeys_popup")
              require("awful.hotkeys_popup.keys")

-- ── Error handling ────────────────────────────────────────────────────────────
naughty.connect_signal("request::display_error", function(message, startup)
  naughty.notification {
    urgency = "critical",
    title   = startup and "Startup error!" or "Runtime error!",
    message = message,
  }
end)

-- ── Theme ─────────────────────────────────────────────────────────────────────
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/theme.lua")

-- ── Layouts ───────────────────────────────────────────────────────────────────
awful.layout.layouts = {
  awful.layout.suit.tile,            -- [1] primary: like Hyprland dwindle master
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.fair,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.floating,
}

-- ── Menu ──────────────────────────────────────────────────────────────────────
local mymainmenu = awful.menu {
  items = {
    { "hotkeys",     function() hotkeys.show_help(nil, awful.screen.focused()) end },
    { "terminal",    os.getenv("TERMINAL") or "kitty" },
    { "restart",     awesome.restart },
    { "quit",        function() awesome.quit() end },
  }
}

-- ── Wibar helpers ─────────────────────────────────────────────────────────────
local cp = beautiful.cp

local function sep(color)
  return wibox.widget {
    markup = '<span foreground="' .. (color or cp.surface1) .. '">  │  </span>',
    widget = wibox.widget.textbox,
  }
end

local function pad(n)
  return wibox.widget {
    forced_width = n or 8,
    widget = wibox.widget.separator,
    opacity = 0,
  }
end

-- ── Load custom widgets ───────────────────────────────────────────────────────
local W = require("widgets")

-- ── Clock + date widget ───────────────────────────────────────────────────────
local clock_widget = wibox.widget {
  format = '<span foreground="' .. cp.lavender .. '">󱑂 %H:%M</span>',
  widget = wibox.widget.textclock,
}
local date_widget = wibox.widget {
  format = '<span foreground="' .. cp.subtext1 .. '"> %a %d %b</span>',
  widget = wibox.widget.textclock,
}

-- ── Taglist + tasklist button bindings ───────────────────────────────────────
local taglist_buttons = gears.table.join(
  awful.button({},     1, function(t) t:view_only() end),
  awful.button({ "Mod4" }, 1, function(t)
    if client.focus then client.focus:move_to_tag(t) end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ "Mod4" }, 3, function(t)
    if client.focus then client.focus:toggle_tag(t) end
  end),
  awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal("request::activate", "tasklist", { raise = true })
    end
  end),
  awful.button({}, 3, function()
    awful.menu.client_list { theme = { width = 250 } }
  end),
  awful.button({}, 4, function() awful.client.focus.byidx(1) end),
  awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)

-- ── Screen setup ─────────────────────────────────────────────────────────────
local function set_wallpaper(s)
  if beautiful.wallpaper then
    local wp = type(beautiful.wallpaper) == "function"
              and beautiful.wallpaper(s) or beautiful.wallpaper
    gears.wallpaper.maximized(wp, s, true)
  else
    gears.wallpaper.set(cp.base)
  end
end

-- Tag names (Nerd Font icons)
local tag_names = { "󰣇", "󰈹", "󰭹", "󰙨", "󰎆", "󰏘", "󰃲", "󰋊", "󰿎" }
--                   1=dev 2=web 3=chat 4=git 5=music 6=art 7=cal 8=files 9=mail

awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)

  -- Tags with default tiling layout + gap applied via beautiful
  awful.tag(tag_names, s, awful.layout.layouts[1])

  -- Prompt box (for legacy awesome prompts, mostly unused with rofi)
  s.mypromptbox = awful.widget.prompt()

  -- Layout indicator
  s.mylayoutbox = awful.widget.layoutbox {
    screen  = s,
    buttons = gears.table.join(
      awful.button({}, 1, function() awful.layout.inc(1)  end),
      awful.button({}, 3, function() awful.layout.inc(-1) end),
      awful.button({}, 4, function() awful.layout.inc(1)  end),
      awful.button({}, 5, function() awful.layout.inc(-1) end)
    )
  }

  -- Taglist
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
    style   = { shape = gears.shape.rounded_rect },
    widget_template = {
      {
        {
          id     = "text_role",
          widget = wibox.widget.textbox,
        },
        left   = 8, right = 8,
        widget = wibox.container.margin,
      },
      id     = "background_role",
      widget = wibox.container.background,
    },
  }

  -- Tasklist
  s.mytasklist = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
    style   = {
      shape        = gears.shape.rounded_rect,
      shape_border_width = 0,
    },
    layout = {
      spacing = 4,
      layout  = wibox.layout.flex.horizontal,
    },
    widget_template = {
      {
        {
          {
            id     = "icon_role",
            widget = wibox.widget.imagebox,
          },
          margins = 4,
          widget  = wibox.container.margin,
        },
        {
          id     = "text_role",
          widget = wibox.widget.textbox,
        },
        layout = wibox.layout.fixed.horizontal,
      },
      left   = 6, right = 6,
      widget = wibox.container.margin,
    },
  }

  -- ── Wibar ──────────────────────────────────────────────────────────────────
  s.mywibar = awful.wibar {
    position = "top",
    screen   = s,
    height   = beautiful.wibar_height,
    bg       = beautiful.wibar_bg,
    fg       = beautiful.wibar_fg,
  }

  -- Rounded pill container helper
  local function pill(widget, bg_color)
    return wibox.widget {
      {
        widget,
        left = 8, right = 8, top = 3, bottom = 3,
        widget = wibox.container.margin,
      },
      bg     = bg_color or cp.surface0,
      shape  = gears.shape.rounded_rect,
      widget = wibox.container.background,
    }
  end

  s.mywibar:setup {
    layout = wibox.layout.align.horizontal,
    expand = "none",

    -- ── Left: launcher icon + tags ──────────────────────────────────────────
    {
      layout = wibox.layout.fixed.horizontal,
      pad(6),
      -- Logo / menu button
      {
        {
          markup = '<span foreground="' .. cp.mauve .. '">  </span>',
          buttons = gears.table.join(
            awful.button({}, 1, function() mymainmenu:toggle() end)
          ),
          widget = wibox.widget.textbox,
        },
        left = 4, right = 4,
        widget = wibox.container.margin,
      },
      sep(),
      s.mytaglist,
      pad(4),
      s.mypromptbox,
    },

    -- ── Center: tasklist ────────────────────────────────────────────────────
    s.mytasklist,

    -- ── Right: system widgets ───────────────────────────────────────────────
    {
      layout = wibox.layout.fixed.horizontal,
      -- BTC
      pill(W.btc, cp.surface0),
      pad(4),
      -- WiFi
      pill(W.wifi, cp.surface0),
      pad(4),
      -- Volume
      pill(W.volume, cp.surface0),
      pad(4),
      -- Battery (hidden on desktops via widget returning "")
      pill(W.battery, cp.surface0),
      pad(4),
      -- CPU
      pill(W.cpu, cp.surface0),
      pad(4),
      -- RAM
      pill(W.ram, cp.surface0),
      sep(),
      -- Date
      date_widget,
      pad(4),
      -- Clock
      clock_widget,
      pad(6),
      -- System tray
      {
        wibox.widget.systray(),
        top = 4, bottom = 4, left = 4, right = 4,
        widget = wibox.container.margin,
      },
      pad(4),
      -- Layout box
      s.mylayoutbox,
      pad(6),
    },
  }
end)

-- ── Mouse bindings (root window) ─────────────────────────────────────────────
-- Root buttons from keybindings (includes Super+scroll workspace switching)
root.buttons(keys.root_buttons)

-- ── Load modular configs ──────────────────────────────────────────────────────
local keys = require("keys.keybindings")
root.keys(keys.global)

require("rules.rules")
require("autostart")

-- ── Signals ───────────────────────────────────────────────────────────────────

-- Titlebar signal
client.connect_signal("request::titlebars", function(c)
  local buttons = gears.table.join(
    awful.button({}, 1, function()
      c:emit_signal("request::activate", "titlebar", { raise = true })
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      c:emit_signal("request::activate", "titlebar", { raise = true })
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c, {
    size = beautiful.titlebar_height,
    bg_normal = beautiful.titlebar_bg_normal,
    bg_focus  = beautiful.titlebar_bg_focus,
  }):setup {
    {
      -- Left: icon
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout  = wibox.layout.fixed.horizontal,
    },
    {
      -- Middle: title
      {
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(c),
      },
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal,
    },
    {
      -- Right: buttons
      awful.titlebar.widget.minimizebutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal,
    },
    layout = wibox.layout.align.horizontal,
  }
end)

-- Auto-hide titlebars for tiled (non-floating) windows
client.connect_signal("property::floating", function(c)
  if c.floating then
    awful.titlebar.show(c)
  else
    awful.titlebar.hide(c)
  end
end)

-- Focus/unfocus border colour
client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Sloppy focus (hover to focus) — comment out if you prefer click-to-focus
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

-- Wallpaper refresh on display change
screen.connect_signal("property::geometry", function(s)
  set_wallpaper(s)
end)

-- Re-apply gaps after tag changes
tag.connect_signal("property::layout", function(t)
  for _, c in ipairs(t:clients()) do
    if c.floating then
      awful.titlebar.show(c)
    else
      awful.titlebar.hide(c)
    end
  end
end)
