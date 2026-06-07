-- RAM usage widget — reads /proc/meminfo, no vicious dependency
local wibox = require("wibox")
local gears = require("gears")
local cp    = require("theme.colors")

local ram_widget = wibox.widget {
  widget = wibox.widget.textbox,
}

local function update()
  local f = io.open("/proc/meminfo", "r")
  if not f then return end

  local total, available = 0, 0
  for line in f:lines() do
    local k, v = line:match("^(%S+):%s+(%d+)")
    if k == "MemTotal"     then total     = tonumber(v) end
    if k == "MemAvailable" then available = tonumber(v) end
  end
  f:close()

  local used_kb  = total - available
  local used_pct = total > 0 and math.floor(used_kb / total * 100) or 0
  local used_mb  = math.floor(used_kb / 1024)

  local color = cp.text
  if used_pct > 80 then color = cp.red
  elseif used_pct > 60 then color = cp.peach end

  local display = used_mb >= 1024
    and string.format("%.1fG", used_mb / 1024)
    or  string.format("%dM",   used_mb)

  ram_widget.markup = string.format(
    '<span foreground="%s"> %s</span>', color, display)
end

gears.timer { timeout = 5, autostart = true, call_now = true, callback = update }

return ram_widget
