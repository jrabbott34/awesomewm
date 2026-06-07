-- Battery widget — reads /sys/class/power_supply/BAT0
local wibox   = require("wibox")
local awful   = require("awful")
local gears   = require("gears")
local cp = require("theme.colors")

local bat_widget = wibox.widget {
  widget = wibox.widget.textbox,
}

local function bat_icon(cap, status)
  if status == "Charging" or status == "Full" then
    if cap >= 90 then return "󰂅"
    elseif cap >= 70 then return "󰂋"
    elseif cap >= 50 then return "󰂉"
    elseif cap >= 30 then return "󰂇"
    else return "󰢜" end
  else
    if cap >= 90 then return "󰁹"
    elseif cap >= 70 then return "󰂁"
    elseif cap >= 50 then return "󰁿"
    elseif cap >= 30 then return "󰁽"
    elseif cap >= 15 then return "󰁻"
    else return "󰁺" end
  end
end

local function update()
  awful.spawn.easy_async_with_shell(
    "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null; " ..
    "cat /sys/class/power_supply/BAT0/status 2>/dev/null",
    function(stdout)
      local lines = {}
      for l in stdout:gmatch("[^\n]+") do lines[#lines+1] = l end
      local cap    = tonumber(lines[1]) or 0
      local status = lines[2] or "Unknown"
      if status == "Unknown" and cap == 0 then
        -- No battery (desktop)
        bat_widget.markup = ""
        return
      end
      local icon  = bat_icon(cap, status)
      local color = cap <= 15 and cp.red
                 or cap <= 30 and cp.yellow
                 or (status == "Charging") and cp.green
                 or cp.text
      bat_widget.markup = string.format(
        '<span foreground="%s">%s %d%%</span>', color, icon, cap)
    end)
end

gears.timer { timeout = 30, autostart = true, callback = update }
update()

return bat_widget
