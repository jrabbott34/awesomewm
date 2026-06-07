-- WiFi widget — shows SSID and signal strength icon
local wibox   = require("wibox")
local awful   = require("awful")
local gears   = require("gears")
local cp = require("theme.colors")

local wifi_widget = wibox.widget {
  widget = wibox.widget.textbox,
}

local function signal_icon(quality)
  if quality >= 75 then return "󰤨"
  elseif quality >= 50 then return "󰤥"
  elseif quality >= 25 then return "󰤢"
  else return "󰤟" end
end

local function update()
  awful.spawn.easy_async_with_shell(
    -- Parse /proc/net/wireless for signal quality
    [[awk 'NR==3{gsub(/\./,"",$3); print $1" "$3}' /proc/net/wireless]],
    function(stdout)
      local iface, quality_str = stdout:match("^%s*(%S-):%s+(%d+)")
      if not iface then
        -- Fallback: try iwgetid for SSID when no wireless data
        awful.spawn.easy_async("iwgetid -r", function(ssid)
          ssid = ssid:gsub("%s+", "")
          if ssid ~= "" then
            wifi_widget.markup = string.format(
              '<span foreground="%s">󰤨 %s</span>', cp.green, ssid)
          else
            wifi_widget.markup = string.format(
              '<span foreground="%s">󰤭 offline</span>', cp.overlay0)
          end
        end)
        return
      end
      local quality = tonumber(quality_str) or 0
      -- /proc/net/wireless quality is 0-70 on most drivers → normalise to %
      local pct = math.min(100, math.floor(quality / 70 * 100))
      awful.spawn.easy_async("iwgetid -r", function(ssid)
        ssid = ssid:gsub("%s+", "")
        local icon  = signal_icon(pct)
        local color = pct >= 50 and cp.green or cp.yellow
        wifi_widget.markup = string.format(
          '<span foreground="%s">%s %s</span>',
          color, icon, ssid ~= "" and ssid or iface)
      end)
    end)
end

gears.timer { timeout = 10, autostart = true, callback = update }
update()

return wifi_widget
