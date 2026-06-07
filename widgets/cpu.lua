-- CPU usage widget — reads /proc/stat, no vicious dependency
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
local cp        = beautiful.cp

local cpu_widget = wibox.widget {
  widget = wibox.widget.textbox,
}

local prev_idle, prev_total = 0, 0

local function update()
  local f = io.open("/proc/stat", "r")
  if not f then return end
  local line = f:read("*l")
  f:close()

  -- cpu user nice system idle iowait irq softirq
  local vals = {}
  for v in line:gmatch("%d+") do vals[#vals+1] = tonumber(v) end

  local idle  = vals[4] + (vals[5] or 0)
  local total = 0
  for _, v in ipairs(vals) do total = total + v end

  local diff_idle  = idle  - prev_idle
  local diff_total = total - prev_total
  local usage = diff_total > 0
    and math.floor(100 * (1 - diff_idle / diff_total))
    or 0

  prev_idle  = idle
  prev_total = total

  local color = cp.text
  if usage > 80 then color = cp.red
  elseif usage > 50 then color = cp.peach end

  cpu_widget.markup = string.format(
    '<span foreground="%s"> %d%%</span>', color, usage)
end

gears.timer { timeout = 2, autostart = true, call_now = true, callback = update }

return cpu_widget
