-- Widget loader — returns a table of all bar widgets
return {
  cpu     = require("widgets.cpu"),
  ram     = require("widgets.ram"),
  volume  = require("widgets.volume"),
  wifi    = require("widgets.wifi"),
  battery = require("widgets.battery"),
  btc     = require("widgets.btc"),
}
