-- AwesomeWM rc.lua — Catppuccin Mocha, Awesome 4.3 compatible
pcall(require, "luarocks.loader")

-- ── Core libraries ────────────────────────────────────────────────────────────
local gears     = require("gears")
local awful     = require("awful")
                  require("awful.autofocus")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local hotkeys   = require("awful.hotkeys_popup")
                  require("awful.hotkeys_popup.keys")

-- ── Error handling (4.3 API) ──────────────────────────────────────────────────
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title  = "Startup error",
    text   = awesome.startup_errors,
  })
end

do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    if in_error then return end
    in_error = true
    naughty.notify({
      preset = naughty.config.presets.critical,
      title  = "Runtime error",
      text   = tostring(err),
    })
    in_error = false
  end)
end

-- ── Theme ─────────────────────────────────────────────────────────────────────
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/theme.lua")
local cp = beautiful.cp

-- ── Layouts ───────────────────────────────────────────────────────────────────
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.fair,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.floating,
}

-- ── Keybindings (load early — needed by root.buttons + rules) ────────────────
local keys = require("keys.keybindings")

-- ── Menu ──────────────────────────────────────────────────────────────────────
local mymainmenu = awful.menu({
  items = {
    { "hotkeys",  function() hotkeys.show_help(nil, awful.screen.focused()) end },
    { "terminal", "alacritty" },
    { "restart",  awesome.restart },
    { "quit",     function() awesome.quit() end },
  }
})

-- ── Wibar helpers ─────────────────────────────────────────────────────────────
local function sep(color)
  return wibox.widget {
    markup = '<span foreground="' .. (color or cp.surface1) .. '">  │  </span>',
    widget = wibox.widget.textbox,
  }
end

local function pad(n)
  return wibox.widget {
    forced_width = n or 8,
    widget       = wibox.widget.separator,
    opacity      = 0,
  }
end

-- ── Widgets ───────────────────────────────────────────────────────────────────
local W
local ok, err = pcall(function() W = require("widgets") end)
if not ok then
  naughty.notify({
    preset  = naughty.config.presets.critical,
    title   = "Widget load error",
    text    = tostring(err),
    timeout = 0,
  })
  -- Fallback empty widgets so the rest of rc.lua doesn't crash
  W = { cpu=wibox.widget.textbox(), ram=wibox.widget.textbox(),
        volume=wibox.widget.textbox(), wifi=wibox.widget.textbox(),
        battery=wibox.widget.textbox(), btc=wibox.widget.textbox() }
end

-- Clock + date
local clock_widget = wibox.widget {
  format = '<span foreground="' .. cp.lavender .. '">󱑂 %H:%M</span>',
  widget = wibox.widget.textclock,
}
local date_widget = wibox.widget {
  format = '<span foreground="' .. cp.subtext1 .. '"> %a %d %b</span>',
  widget = wibox.widget.textclock,
}

-- ── Taglist buttons ───────────────────────────────────────────────────────────
local taglist_buttons = gears.table.join(
  awful.button({},        1, function(t) t:view_only() end),
  awful.button({ "Mod4"}, 1, function(t)
    if client.focus then client.focus:move_to_tag(t) end
  end),
  awful.button({},        3, awful.tag.viewtoggle),
  awful.button({ "Mod4"}, 3, function(t)
    if client.focus then client.focus:toggle_tag(t) end
  end),
  awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- ── Tasklist buttons ──────────────────────────────────────────────────────────
local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c.minimized = false
      if not c:isvisible() then
        awful.tag.viewonly(c:tags()[1])
      end
      client.focus = c
      c:raise()
    end
  end),
  awful.button({}, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({}, 4, function() awful.client.focus.byidx(1) end),
  awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)

-- ── Wallpaper ─────────────────────────────────────────────────────────────────
local function set_wallpaper(s)
  if beautiful.wallpaper then
    local wp = type(beautiful.wallpaper) == "function"
              and beautiful.wallpaper(s) or beautiful.wallpaper
    gears.wallpaper.maximized(wp, s, true)
  else
    gears.wallpaper.set(cp.base)
  end
end

screen.connect_signal("property::geometry", set_wallpaper)

-- ── Tag names ─────────────────────────────────────────────────────────────────
local tag_names = { "󰣇", "󰈹", "󰭹", "󰙨", "󰎆", "󰏘", "󰃲", "󰋊", "󰿎" }

-- ── Per-screen setup ──────────────────────────────────────────────────────────
awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)

  awful.tag(tag_names, s, awful.layout.layouts[1])

  s.mypromptbox = awful.widget.prompt()

  -- layoutbox: 4.3 takes screen directly
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function() awful.layout.inc( 1) end),
    awful.button({}, 3, function() awful.layout.inc(-1) end),
    awful.button({}, 4, function() awful.layout.inc( 1) end),
    awful.button({}, 5, function() awful.layout.inc(-1) end)
  ))

  -- Taglist
  s.mytaglist = awful.widget.taglist(
    s,
    awful.widget.taglist.filter.all,
    taglist_buttons
  )

  -- Tasklist
  s.mytasklist = awful.widget.tasklist(
    s,
    awful.widget.tasklist.filter.currenttags,
    tasklist_buttons
  )

  -- ── Wibar ────────────────────────────────────────────────────────────────────
  s.mywibar = awful.wibar({
    position = "top",
    screen   = s,
    height   = beautiful.wibar_height,
    bg       = beautiful.wibar_bg,
    fg       = beautiful.wibar_fg,
  })

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

  s.mywibar:setup({
    layout = wibox.layout.align.horizontal,

    -- Left
    {
      layout = wibox.layout.fixed.horizontal,
      pad(6),
      {
        {
          markup  = '<span foreground="' .. cp.mauve .. '">  </span>',
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

    -- Center
    s.mytasklist,

    -- Right
    {
      layout = wibox.layout.fixed.horizontal,
      pill(W.btc,     cp.surface0), pad(4),
      pill(W.wifi,    cp.surface0), pad(4),
      pill(W.volume,  cp.surface0), pad(4),
      pill(W.battery, cp.surface0), pad(4),
      pill(W.cpu,     cp.surface0), pad(4),
      pill(W.ram,     cp.surface0),
      sep(),
      date_widget, pad(4),
      clock_widget, pad(6),
      {
        wibox.widget.systray(),
        top = 4, bottom = 4, left = 4, right = 4,
        widget = wibox.container.margin,
      },
      pad(4),
      s.mylayoutbox,
      pad(6),
    },
  })
end)

-- ── Root mouse + keys ─────────────────────────────────────────────────────────
root.buttons(keys.root_buttons)
root.keys(keys.global)

-- ── Rules + autostart ────────────────────────────────────────────────────────
require("rules.rules")
require("autostart")

-- ── Signals ───────────────────────────────────────────────────────────────────

-- Titlebars
client.connect_signal("request::titlebars", function(c)
  local buttons = gears.table.join(
    awful.button({}, 1, function()
      client.focus = c
      c:raise()
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      client.focus = c
      c:raise()
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c, {
    size     = beautiful.titlebar_height,
    bg_normal = beautiful.titlebar_bg_normal,
    bg_focus  = beautiful.titlebar_bg_focus,
  }):setup({
    { awful.titlebar.widget.iconwidget(c), buttons = buttons, layout = wibox.layout.fixed.horizontal },
    { { align = "center", widget = awful.titlebar.widget.titlewidget(c) }, buttons = buttons, layout = wibox.layout.flex.horizontal },
    { awful.titlebar.widget.minimizebutton(c), awful.titlebar.widget.maximizedbutton(c), awful.titlebar.widget.closebutton(c), layout = wibox.layout.fixed.horizontal },
    layout = wibox.layout.align.horizontal,
  })
end)

-- Auto-hide titlebars on tiled windows
client.connect_signal("property::floating", function(c)
  if c.floating then awful.titlebar.show(c)
  else               awful.titlebar.hide(c) end
end)

-- Border colours
client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Hover-to-focus (sloppy focus)
client.connect_signal("mouse::enter", function(c)
  if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    and awful.client.focus.filter(c) then
    client.focus = c
  end
end)

-- Re-apply titlebar state after layout change
tag.connect_signal("property::layout", function(t)
  for _, c in ipairs(t:clients()) do
    if c.floating then awful.titlebar.show(c)
    else               awful.titlebar.hide(c) end
  end
end)
