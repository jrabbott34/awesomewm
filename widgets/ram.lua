-- RAM usage widget using vicious
local wibox   = require("wibox")
local vicious = require("vicious")
local beautiful = require("beautiful")
local cp = beautiful.cp

local ram_icon = wibox.widget {
  markup = '<span foreground="' .. cp.mauve .. '"> </span>',
  widget = wibox.widget.textbox,
}

local ram_text = wibox.widget {
  widget = wibox.widget.textbox,
}

vicious.cache(vicious.widgets.mem)
vicious.register(ram_text, vicious.widgets.mem,
  function(_, args)
    -- args[1]=used%, args[2]=used MiB, args[3]=total MiB
    local used_pct = args[1]
    local used_mb  = args[2]
    local color = cp.text
    if used_pct > 80 then color = cp.red
    elseif used_pct > 60 then color = cp.peach
    end
    local display = used_mb >= 1024
      and string.format("%.1fG", used_mb / 1024)
      or  string.format("%dM",  used_mb)
    return string.format('<span foreground="%s">%s</span>', color, display)
  end, 5)

local ram_widget = wibox.widget {
  ram_icon,
  ram_text,
  layout = wibox.layout.fixed.horizontal,
  spacing = 2,
}

return ram_widget
