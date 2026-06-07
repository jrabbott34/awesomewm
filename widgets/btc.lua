-- BTC price ticker — queries CoinGecko's public API every 5 minutes
local wibox   = require("wibox")
local awful   = require("awful")
local gears   = require("gears")
local cp = require("theme.colors")

local btc_widget = wibox.widget {
  markup = '<span foreground="' .. cp.yellow .. '">󰿏 …</span>',
  widget = wibox.widget.textbox,
}

local last_price = nil
local last_dir   = ""   -- "up", "down", or ""

local function update()
  awful.spawn.easy_async(
    "curl -sf 'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd'",
    function(stdout)
      local price = tonumber(stdout:match('"usd":(%d+%.?%d*)'))
      if not price then
        btc_widget.markup = string.format(
          '<span foreground="%s">󰿏 err</span>', cp.overlay1)
        return
      end
      local arrow = ""
      local color = cp.yellow
      if last_price then
        if price > last_price then
          arrow = " 󰜷"; color = cp.green
        elseif price < last_price then
          arrow = " 󰜮"; color = cp.red
        end
      end
      last_price = price
      -- Format with commas: 98,500
      local formatted = tostring(math.floor(price)):reverse()
                          :gsub("(%d%d%d)", "%1,")
                          :reverse():gsub("^,", "")
      btc_widget.markup = string.format(
        '<span foreground="%s">󰿏 $%s%s</span>', color, formatted, arrow)
    end)
end

gears.timer { timeout = 300, autostart = true, callback = update }
update()

return btc_widget
