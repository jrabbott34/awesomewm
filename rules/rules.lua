-- Window rules — ported from hyprland.lua hl.window_rule() blocks
local awful  = require("awful")
local keys   = require("keys.keybindings")
local beautiful = require("beautiful")

awful.rules.rules = {
  -- ── Default rule: all clients ──────────────────────────────────────────────
  -- Matches Hyprland's suppress-maximize rule for all classes
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
      size_hints_honor = false,   -- suppresses maximize hints (Hyprland suppress_event = "maximize")
    }
  },

  -- ── Titlebars: enable for all normal/dialog windows ───────────────────────
  { rule_any = { type = { "normal", "dialog" } },
    properties = { titlebars_enabled = true } },

  -- ── Float: pavucontrol — float = true, center = true, size = "700 500" ────
  { rule = { class = "org.pulseaudio.pavucontrol" },
    properties = {
      floating  = true,
      width     = 700, height = 500,
      placement = awful.placement.centered,
    }
  },

  -- ── Float: blueman — size = "800 600" ────────────────────────────────────
  { rule = { class = "blueman-manager" },
    properties = {
      floating  = true,
      width     = 800, height = 600,
      placement = awful.placement.centered,
    }
  },

  -- ── Float: nm-connection-editor ───────────────────────────────────────────
  { rule = { class = "nm-connection-editor" },
    properties = { floating = true, placement = awful.placement.centered } },

  -- ── Float: nmtui terminal — center, 600x400 ──────────────────────────────
  { rule = { name = "nmtui" },
    properties = {
      floating  = true,
      width     = 600, height = 400,
      placement = awful.placement.centered,
    }
  },

  -- ── Float: appearance tools ────────────────────────────────────────────────
  { rule_any = { class = { "lxappearance", "nwg-look" } },
    properties = { floating = true, placement = awful.placement.centered } },

  -- ── Float: printer config ─────────────────────────────────────────────────
  { rule = { class = "system-config-printer" },
    properties = { floating = true, placement = awful.placement.centered } },

  -- ── Float: file operation dialogs ─────────────────────────────────────────
  { rule_any = {
      name = { "File Operation Progress", "Confirm to replace files" }
    },
    properties = { floating = true, placement = awful.placement.centered }
  },

  -- ── Float: yad dialogs ───────────────────────────────────────────────────
  { rule = { class = "yad" },
    properties = { floating = true, placement = awful.placement.centered } },

  -- ── Float: misc standard popups ───────────────────────────────────────────
  { rule_any = {
      instance = { "copyq", "pinentry" },
      class    = { "Arandr", "Gpick", "Sxiv", "Wpa_gui", "feh" },
      role     = { "AlarmWindow", "ConfigManager", "pop-up" },
      name     = { "Event Tester" },
    },
    properties = { floating = true, placement = awful.placement.centered }
  },

  -- ── Tile: LibreOffice (matching tile = true rule) ─────────────────────────
  { rule = { class = "soffice" },
    properties = { floating = false } },

  -- ── Tag assignments ────────────────────────────────────────────────────────
  { rule_any = { class = { "firefox", "chromium", "brave-browser" } },
    properties = { tag = "󰈹" } },    -- tag 2
  { rule_any = { class = { "discord", "Slack", "TelegramDesktop" } },
    properties = { tag = "󰭹" } },    -- tag 3
  { rule_any = { class = { "Spotify", "ncspot" } },
    properties = { tag = "󰎆" } },    -- tag 5
  { rule_any = { class = { "Gimp", "Inkscape" } },
    properties = { tag = "󰏘", floating = false } },  -- tag 6, tiled
}
