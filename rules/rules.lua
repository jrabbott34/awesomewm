-- Window rules
local awful  = require("awful")
local keys   = require("keys.keybindings")
local beautiful = require("beautiful")

awful.rules.rules = {
  -- ── Default rule: all clients ──────────────────────────────────────────────
  { rule = {},
    properties = {
      border_width     = beautiful.border_width,
      border_color     = beautiful.border_normal,
      focus            = awful.client.focus.filter,
      raise            = true,
      keys             = keys.client,
      buttons          = keys.client_buttons,
      screen           = awful.screen.preferred,
      placement        = awful.placement.no_overlap + awful.placement.no_offscreen,
      size_hints_honor = false,   -- ignore X11 size hints (prevents gaps)
    }
  },

  -- ── Floating clients ──────────────────────────────────────────────────────
  { rule_any = {
      instance = { "copyq", "pinentry" },
      class    = {
        "Arandr", "Blueman-manager", "Gpick", "Kruler",
        "Sxiv", "Wpa_gui", "Pavucontrol", "Nm-connection-editor",
        "feh", "mpv",
      },
      name     = { "Event Tester" },
      role     = { "AlarmWindow", "ConfigManager", "pop-up" },
    },
    properties = { floating = true, placement = awful.placement.centered }
  },

  -- ── Tag assignments ───────────────────────────────────────────────────────
  { rule_any = { class = { "firefox", "chromium", "brave-browser" } },
    properties = { tag = "2" } },
  { rule_any = { class = { "discord", "Slack", "TelegramDesktop" } },
    properties = { tag = "3" } },
  { rule_any = { class = { "Spotify", "ncspot" } },
    properties = { tag = "5" } },
  { rule_any = { class = { "Gimp", "Inkscape" } },
    properties = { tag = "6", floating = true } },

  -- ── Titlebars: disable for tiling, enable for floating ────────────────────
  { rule_any = { type = { "normal", "dialog" } },
    properties = { titlebars_enabled = true } },
}
