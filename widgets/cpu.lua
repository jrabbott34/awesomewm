-- CPU usage widget using vicious
local wibox   = require("wibox")
local vicious = require("vicious")
local beautiful = require("beautiful")
local cp = beautiful.cp

local cpu_icon = wibox.widget {
  markup = '<span foreground="' .. cp.peach .. '"> </span>',
  widget = wibox.widget.textbox,
}

local cpu_text = wibox.widget {
  widget = wibox.widget.textbox,
}

vicious.cache(vicious.widgets.cpu)
vicious.register(cpu_text, vicious.widgets.cpu,
  function(_, args)
    local usage = args[1]
    local color = cp.text
    if usage > 80 then color = cp.red
    elseif usage > 50 then color = cp.peach
    end
    return string.format('<span foreground="%s">%d%%</span>', color, usage)
  end, 2)

local cpu_widget = wibox.widget {
  cpu_icon,
  cpu_text,
  layout = wibox.layout.fixed.horizontal,
  spacing = 2,
}

return cpu_widget
