-- Volume widget (PulseAudio/PipeWire via pactl)
local wibox   = require("wibox")
local awful   = require("awful")
local gears   = require("gears")
local cp = require("theme.colors")

local vol_widget = wibox.widget {
  widget = wibox.widget.textbox,
}

local function get_icon(vol, muted)
  if muted or vol == 0 then return "󰝟" end
  if vol < 33  then return "󰕿" end
  if vol < 66  then return "󰖀" end
  return "󰕾"
end

local function update()
  awful.spawn.easy_async(
    "pactl get-sink-volume @DEFAULT_SINK@",
    function(vol_out)
      awful.spawn.easy_async(
        "pactl get-sink-mute @DEFAULT_SINK@",
        function(mute_out)
          local vol  = tonumber(vol_out:match("(%d+)%%")) or 0
          local muted = mute_out:match("Mute: yes") ~= nil
          local icon  = get_icon(vol, muted)
          local color = muted and cp.overlay1 or cp.sky
          vol_widget.markup = string.format(
            '<span foreground="%s">%s %d%%</span>',
            color, icon, vol
          )
        end)
    end)
end

-- Refresh every 5 seconds and on scroll
gears.timer { timeout = 5, autostart = true, callback = update }
update()

vol_widget:buttons(gears.table.join(
  awful.button({}, 4, function()
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
    gears.timer.start_new(0.1, function() update(); return false end)
  end),
  awful.button({}, 5, function()
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
    gears.timer.start_new(0.1, function() update(); return false end)
  end),
  awful.button({}, 1, function()
    awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
    gears.timer.start_new(0.1, function() update(); return false end)
  end)
))

return vol_widget
