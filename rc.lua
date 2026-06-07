-- AwesomeWM rc.lua — Catppuccin Mocha, fully self-contained, Awesome 4.3
pcall(require, "luarocks.loader")

local gears     = require("gears")
local awful     = require("awful")
                  require("awful.autofocus")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local hotkeys   = require("awful.hotkeys_popup")
                  require("awful.hotkeys_popup.keys")

-- ── Error handling ────────────────────────────────────────────────────────────
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
    title = "Startup error", text = awesome.startup_errors })
end
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    if in_error then return end
    in_error = true
    naughty.notify({ preset = naughty.config.presets.critical,
      title = "Runtime error", text = tostring(err), timeout = 0 })
    in_error = false
  end)
end

-- ── Catppuccin Mocha palette ──────────────────────────────────────────────────
local cp = {
  base     = "#1e1e2e", mantle   = "#181825", crust    = "#11111b",
  surface0 = "#313244", surface1 = "#45475a", surface2 = "#585b70",
  overlay0 = "#6c7086", overlay1 = "#7f849c", overlay2 = "#9399b2",
  subtext0 = "#a6adc8", subtext1 = "#bac2de", text     = "#cdd6f4",
  lavender = "#b4befe", blue     = "#89b4fa", sapphire = "#74c7ec",
  sky      = "#89dceb", teal     = "#94e2d5", green    = "#a6e3a1",
  yellow   = "#f9e2af", peach    = "#fab387", maroon   = "#eba0ac",
  red      = "#f38ba8", mauve    = "#cba6f7", pink     = "#f5c2e7",
  flamingo = "#f2cdcd", rosewater= "#f5e0dc",
}

-- ── Theme (inline) ────────────────────────────────────────────────────────────
local theme_path = gears.filesystem.get_configuration_dir() .. "theme/theme.lua"
beautiful.init(theme_path)

-- Override key colours directly in case theme.lua had issues
beautiful.bg_normal        = cp.base
beautiful.bg_focus         = cp.surface0
beautiful.bg_urgent        = cp.red
beautiful.fg_normal        = cp.subtext1
beautiful.fg_focus         = cp.text
beautiful.fg_urgent        = cp.base
beautiful.border_width     = 2
beautiful.border_normal    = cp.surface0
beautiful.border_focus     = cp.mauve
beautiful.useless_gap      = 2
beautiful.wibar_bg         = cp.mantle
beautiful.wibar_fg         = cp.text
beautiful.wibar_height     = 32
beautiful.taglist_bg_focus = cp.mauve
beautiful.taglist_fg_focus = cp.base
beautiful.font             = "FiraCode Nerd Font 10"

-- ── Layouts ───────────────────────────────────────────────────────────────────
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.fair,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.floating,
}

-- ── Keybindings ───────────────────────────────────────────────────────────────
local mod = "Mod4"

local globalkeys = gears.table.join(
  awful.key({ mod }, "F1", hotkeys.show_help,
    { description = "show help", group = "awesome" }),
  awful.key({ mod, "Control" }, "r", awesome.restart,
    { description = "reload", group = "awesome" }),
  awful.key({ mod, "Control" }, "q", awesome.quit,
    { description = "quit", group = "awesome" }),

  -- Focus
  awful.key({ mod }, "left",  function() awful.client.focus.bydirection("left")  end),
  awful.key({ mod }, "right", function() awful.client.focus.bydirection("right") end),
  awful.key({ mod }, "up",    function() awful.client.focus.bydirection("up")    end),
  awful.key({ mod }, "down",  function() awful.client.focus.bydirection("down")  end),
  awful.key({ mod }, "h",     function() awful.client.focus.bydirection("left")  end),
  awful.key({ mod }, "k",     function() awful.client.focus.bydirection("up")    end),

  -- Swap
  awful.key({ mod, "Shift" }, "left",  function() awful.client.swap.bydirection("left")  end),
  awful.key({ mod, "Shift" }, "right", function() awful.client.swap.bydirection("right") end),
  awful.key({ mod, "Shift" }, "up",    function() awful.client.swap.bydirection("up")    end),
  awful.key({ mod, "Shift" }, "down",  function() awful.client.swap.bydirection("down")  end),

  -- Resize
  awful.key({ mod, "Control" }, "right", function()
    if client.focus and client.focus.floating then client.focus:relative_move(0,0,30,0)
    else awful.tag.incmwfact(0.03) end end),
  awful.key({ mod, "Control" }, "left", function()
    if client.focus and client.focus.floating then client.focus:relative_move(0,0,-30,0)
    else awful.tag.incmwfact(-0.03) end end),
  awful.key({ mod, "Control" }, "up", function()
    if client.focus and client.focus.floating then client.focus:relative_move(0,0,0,-30)
    else awful.tag.incmwfact(-0.03) end end),
  awful.key({ mod, "Control" }, "down", function()
    if client.focus and client.focus.floating then client.focus:relative_move(0,0,0,30)
    else awful.tag.incmwfact(0.03) end end),

  -- Layout
  awful.key({ mod }, "j", function() awful.layout.inc(1)  end),
  awful.key({ mod, "Shift" }, "j", function() awful.layout.inc(-1) end),

  -- Launchers
  awful.key({ mod }, "Return", function() awful.spawn("alacritty")           end),
  awful.key({ mod }, "space",  function() awful.spawn("wofi --show drun")    end),
  awful.key({ mod }, "e",      function() awful.spawn("thunar")              end),
  awful.key({ mod }, "b",      function() awful.spawn("firefox")             end),
  awful.key({ mod }, "l",      function() awful.spawn("hyprlock")            end),
  awful.key({ mod, "Shift" }, "e", function() awful.spawn("wlogout")         end),
  awful.key({ mod, "Shift" }, "b", function()
    local s = awful.screen.focused()
    if s.mywibar then s.mywibar.visible = not s.mywibar.visible end
  end),
  awful.key({ mod, "Shift" }, "w", function()
    awful.spawn.with_shell("feh --bg-fill --randomize ~/Pictures/")
  end),

  -- Screenshots
  awful.key({}, "Print", function()
    awful.spawn.with_shell("maim -s | xclip -selection clipboard -t image/png && notify-send Screenshot 'Copied to clipboard'")
  end),
  awful.key({ mod }, "Print", function()
    awful.spawn.with_shell("maim ~/Pictures/screenshots/$(date +%Y%m%d-%H%M%S).png && notify-send Screenshot Saved")
  end),

  -- Media
  awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")   end),
  awful.key({}, "XF86AudioLowerVolume", function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")   end),
  awful.key({}, "XF86AudioMute",        function() awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")  end),
  awful.key({}, "XF86AudioPlay",        function() awful.spawn("playerctl play-pause") end),
  awful.key({}, "XF86AudioNext",        function() awful.spawn("playerctl next")        end),
  awful.key({}, "XF86AudioPrev",        function() awful.spawn("playerctl previous")    end),
  awful.key({}, "XF86MonBrightnessUp",  function() awful.spawn("brightnessctl set +5%") end),
  awful.key({}, "XF86MonBrightnessDown",function() awful.spawn("brightnessctl set 5%-") end),

  -- Tab
  awful.key({ mod }, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then client.focus:raise() end
  end)
)

-- Tags 1-9
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
    awful.key({ mod }, "#" .. i + 9, function()
      local t = awful.screen.focused().tags[i]
      if t then t:view_only() end
    end),
    awful.key({ mod, "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local t = client.focus.screen.tags[i]
        if t then client.focus:move_to_tag(t) end
      end
    end)
  )
end

local clientkeys = gears.table.join(
  awful.key({ mod }, "q",           function(c) c:kill() end),
  awful.key({ mod }, "f",           function(c) c.fullscreen = not c.fullscreen; c:raise() end),
  awful.key({ mod }, "v",           awful.client.floating.toggle),
  awful.key({ mod }, "m",           function(c) c.maximized = not c.maximized; c:raise() end),
  awful.key({ mod }, "n",           function(c) c.minimized = true end),
  awful.key({ mod }, "t",           function(c) c.ontop = not c.ontop end),
  awful.key({ mod, "Shift" }, "Return", function(c) c:swap(awful.client.getmaster()) end),
  awful.key({ mod, "Shift" }, ".",  function(c) c:move_to_screen() end)
)

local clientbuttons = gears.table.join(
  awful.button({}, 1, function(c) client.focus = c; c:raise() end),
  awful.button({ mod }, 1, function(c) client.focus = c; c:raise(); awful.mouse.client.move(c) end),
  awful.button({ mod }, 3, function(c) client.focus = c; c:raise(); awful.mouse.client.resize(c) end)
)

root.keys(globalkeys)
root.buttons(gears.table.join(
  awful.button({}, 3, function() end),
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)
))

-- ── Rules ─────────────────────────────────────────────────────────────────────
awful.rules.rules = {
  { rule = {}, properties = {
      border_width  = beautiful.border_width,
      border_color  = beautiful.border_normal,
      focus         = awful.client.focus.filter,
      raise         = true,
      keys          = clientkeys,
      buttons       = clientbuttons,
      screen        = awful.screen.preferred,
      placement     = awful.placement.no_overlap + awful.placement.no_offscreen,
      size_hints_honor = false,
    }
  },
  { rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },
  { rule_any = {
      class = { "org.pulseaudio.pavucontrol" },
    }, properties = { floating = true, placement = awful.placement.centered } },
  { rule_any = { class = { "blueman-manager" } },
    properties = { floating = true, placement = awful.placement.centered } },
  { rule_any = { role = { "pop-up" }, name = { "Event Tester" } },
    properties = { floating = true, placement = awful.placement.centered } },
}

-- ── Autostart ────────────────────────────────────────────────────────────────
local function run_once(cmd)
  local name = cmd:match("^%S+"):match("[^/]+$")
  awful.spawn.with_shell(string.format("pgrep -u $USER -x '%s' > /dev/null || %s", name, cmd))
end

run_once("picom")
run_once("nm-applet --indicator")
run_once("blueman-applet")
run_once("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
run_once("dunst")
awful.spawn.with_shell("~/.fehbg 2>/dev/null || feh --bg-fill ~/Pictures/wallpaper.jpg 2>/dev/null || true")
awful.spawn.with_shell("setxkbmap -layout us")
awful.spawn.with_shell("xset r rate 300 50")

-- ── Widgets (inline, no external deps) ───────────────────────────────────────

-- CPU
local cpu_widget = wibox.widget { widget = wibox.widget.textbox }
local _cpu_prev_idle, _cpu_prev_total = 0, 0
gears.timer { timeout = 2, autostart = true, call_now = true, callback = function()
  local f = io.open("/proc/stat", "r")
  if not f then return end
  local line = f:read("*l"); f:close()
  local vals = {}
  for v in line:gmatch("%d+") do vals[#vals+1] = tonumber(v) end
  local idle  = vals[4] + (vals[5] or 0)
  local total = 0; for _, v in ipairs(vals) do total = total + v end
  local pct = total - _cpu_prev_total > 0
    and math.floor(100 * (1 - (idle - _cpu_prev_idle) / (total - _cpu_prev_total))) or 0
  _cpu_prev_idle, _cpu_prev_total = idle, total
  local col = pct > 80 and cp.red or pct > 50 and cp.peach or cp.text
  cpu_widget.markup = string.format('<span foreground="%s"> %d%%</span>', col, pct)
end }

-- RAM
local ram_widget = wibox.widget { widget = wibox.widget.textbox }
gears.timer { timeout = 5, autostart = true, call_now = true, callback = function()
  local f = io.open("/proc/meminfo", "r"); if not f then return end
  local total, avail = 0, 0
  for line in f:lines() do
    local k, v = line:match("^(%S+):%s+(%d+)")
    if k == "MemTotal"     then total = tonumber(v) end
    if k == "MemAvailable" then avail = tonumber(v) end
  end
  f:close()
  local used_mb  = math.floor((total - avail) / 1024)
  local used_pct = total > 0 and math.floor((total - avail) / total * 100) or 0
  local col = used_pct > 80 and cp.red or used_pct > 60 and cp.peach or cp.text
  local disp = used_mb >= 1024 and string.format("%.1fG", used_mb/1024) or used_mb.."M"
  ram_widget.markup = string.format('<span foreground="%s"> %s</span>', col, disp)
end }

-- Volume
local vol_widget = wibox.widget { widget = wibox.widget.textbox }
local function vol_update()
  awful.spawn.easy_async("pactl get-sink-volume @DEFAULT_SINK@", function(vo)
    awful.spawn.easy_async("pactl get-sink-mute @DEFAULT_SINK@", function(mo)
      local vol   = tonumber(vo:match("(%d+)%%")) or 0
      local muted = mo:match("Mute: yes") ~= nil
      local icon  = muted and "󰝟" or vol < 33 and "󰕿" or vol < 66 and "󰖀" or "󰕾"
      local col   = muted and cp.overlay1 or cp.sky
      vol_widget.markup = string.format('<span foreground="%s">%s %d%%</span>', col, icon, vol)
    end)
  end)
end
gears.timer { timeout = 5, autostart = true, call_now = true, callback = vol_update }
vol_widget:buttons(gears.table.join(
  awful.button({}, 4, function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%");  gears.timer.start_new(0.1, function() vol_update(); return false end) end),
  awful.button({}, 5, function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%");  gears.timer.start_new(0.1, function() vol_update(); return false end) end),
  awful.button({}, 1, function() awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"); gears.timer.start_new(0.1, function() vol_update(); return false end) end)
))

-- WiFi
local wifi_widget = wibox.widget { widget = wibox.widget.textbox }
gears.timer { timeout = 10, autostart = true, call_now = true, callback = function()
  awful.spawn.easy_async("iwgetid -r", function(ssid)
    ssid = ssid:gsub("%s+", "")
    if ssid ~= "" then
      wifi_widget.markup = string.format('<span foreground="%s">󰤨 %s</span>', cp.green, ssid)
    else
      wifi_widget.markup = string.format('<span foreground="%s">󰤭 offline</span>', cp.overlay0)
    end
  end)
end }

-- Battery
local bat_widget = wibox.widget { widget = wibox.widget.textbox }
gears.timer { timeout = 30, autostart = true, call_now = true, callback = function()
  awful.spawn.easy_async_with_shell(
    "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null; cat /sys/class/power_supply/BAT0/status 2>/dev/null",
    function(out)
      local lines = {}
      for l in out:gmatch("[^\n]+") do lines[#lines+1] = l end
      local cap    = tonumber(lines[1]) or 0
      local status = lines[2] or "Unknown"
      if cap == 0 and status == "Unknown" then bat_widget.markup = ""; return end
      local charging = status == "Charging"
      local icon = charging and "󰂄" or cap >= 80 and "󰁹" or cap >= 60 and "󰂁" or cap >= 40 and "󰁿" or cap >= 20 and "󰁽" or "󰁺"
      local col  = cap <= 15 and cp.red or cap <= 30 and cp.yellow or charging and cp.green or cp.text
      bat_widget.markup = string.format('<span foreground="%s">%s %d%%</span>', col, icon, cap)
    end)
end }

-- BTC
local btc_widget = wibox.widget {
  markup = string.format('<span foreground="%s">󰿏 …</span>', cp.yellow),
  widget = wibox.widget.textbox,
}
local _btc_last = nil
gears.timer { timeout = 300, autostart = true, call_now = true, callback = function()
  awful.spawn.easy_async(
    "curl -sf 'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd'",
    function(out)
      local price = tonumber(out:match('"usd":(%d+%.?%d*)'))
      if not price then
        btc_widget.markup = string.format('<span foreground="%s">󰿏 err</span>', cp.overlay1)
        return
      end
      local arrow = _btc_last and (price > _btc_last and " 󰜷" or price < _btc_last and " 󰜮" or "") or ""
      local col   = _btc_last and (price > _btc_last and cp.green or price < _btc_last and cp.red or cp.yellow) or cp.yellow
      _btc_last   = price
      local fmt   = tostring(math.floor(price)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,","")
      btc_widget.markup = string.format('<span foreground="%s">󰿏 $%s%s</span>', col, fmt, arrow)
    end)
end }

-- Clock + date
local clock_widget = wibox.widget {
  format = '<span foreground="' .. cp.lavender .. '">󱑂 %H:%M</span>',
  widget = wibox.widget.textclock,
}
local date_widget = wibox.widget {
  format = '<span foreground="' .. cp.subtext1 .. '"> %a %d %b</span>',
  widget = wibox.widget.textclock,
}

-- ── Screen setup ─────────────────────────────────────────────────────────────
local function set_wallpaper(s)
  if beautiful.wallpaper then
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
  else
    gears.wallpaper.set(cp.base)
  end
end
screen.connect_signal("property::geometry", set_wallpaper)

local tag_names = { "󰣇", "󰈹", "󰭹", "󰙨", "󰎆", "󰏘", "󰃲", "󰋊", "󰿎" }

local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then c.minimized = true
    else client.focus = c; c:raise() end
  end),
  awful.button({}, 3, function() awful.menu.client_list({ theme = { width = 250 } }) end),
  awful.button({}, 4, function() awful.client.focus.byidx(1)  end),
  awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)

awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)
  awful.tag(tag_names, s, awful.layout.layouts[1])
  s.mypromptbox = awful.widget.prompt()

  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function() awful.layout.inc( 1) end),
    awful.button({}, 3, function() awful.layout.inc(-1) end)
  ))

  s.mytaglist  = awful.widget.taglist(s,  awful.widget.taglist.filter.all,     taglist_buttons)
  s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

  local function pill(w)
    return wibox.widget {
      { w, left=8, right=8, top=3, bottom=3, widget=wibox.container.margin },
      bg=cp.surface0, shape=gears.shape.rounded_rect, widget=wibox.container.background,
    }
  end
  local function pad(n)
    return wibox.widget { forced_width=n or 8, widget=wibox.widget.separator, opacity=0 }
  end
  local function vsep()
    return wibox.widget {
      markup='<span foreground="'..cp.surface1..'">  │  </span>',
      widget=wibox.widget.textbox,
    }
  end

  s.mywibar = awful.wibar({ position="top", screen=s, height=32, bg=cp.mantle, fg=cp.text })
  s.mywibar:setup({
    layout = wibox.layout.align.horizontal,
    { -- Left
      layout = wibox.layout.fixed.horizontal,
      pad(6),
      {
        { markup='<span foreground="'..cp.mauve..'">  </span>', widget=wibox.widget.textbox },
        left=4, right=4, widget=wibox.container.margin,
      },
      vsep(), s.mytaglist, pad(4), s.mypromptbox,
    },
    s.mytasklist, -- Center
    { -- Right
      layout = wibox.layout.fixed.horizontal,
      pill(btc_widget),  pad(4),
      pill(wifi_widget), pad(4),
      pill(vol_widget),  pad(4),
      pill(bat_widget),  pad(4),
      pill(cpu_widget),  pad(4),
      pill(ram_widget),
      vsep(),
      date_widget, pad(4), clock_widget, pad(6),
      { wibox.widget.systray(), top=4, bottom=4, left=4, right=4, widget=wibox.container.margin },
      pad(4), s.mylayoutbox, pad(6),
    },
  })
end)

-- ── Signals ───────────────────────────────────────────────────────────────────
client.connect_signal("request::titlebars", function(c)
  local buttons = gears.table.join(
    awful.button({}, 1, function() client.focus=c; c:raise(); awful.mouse.client.move(c) end),
    awful.button({}, 3, function() client.focus=c; c:raise(); awful.mouse.client.resize(c) end)
  )
  awful.titlebar(c):setup({
    { awful.titlebar.widget.iconwidget(c), buttons=buttons, layout=wibox.layout.fixed.horizontal },
    { { align="center", widget=awful.titlebar.widget.titlewidget(c) }, buttons=buttons, layout=wibox.layout.flex.horizontal },
    { awful.titlebar.widget.minimizebutton(c), awful.titlebar.widget.maximizedbutton(c), awful.titlebar.widget.closebutton(c), layout=wibox.layout.fixed.horizontal },
    layout = wibox.layout.align.horizontal,
  })
end)

client.connect_signal("property::floating", function(c)
  if c.floating then awful.titlebar.show(c) else awful.titlebar.hide(c) end
end)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

client.connect_signal("mouse::enter", function(c)
  if awful.client.focus.filter(c) then client.focus = c end
end)

tag.connect_signal("property::layout", function(t)
  for _, c in ipairs(t:clients()) do
    if c.floating then awful.titlebar.show(c) else awful.titlebar.hide(c) end
  end
end)
