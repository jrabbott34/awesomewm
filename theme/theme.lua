-- Catppuccin Mocha theme for Awesome WM
local theme_assets = require("beautiful.theme_assets")
local xresources   = require("beautiful.xresources")
local dpi          = xresources.apply_dpi
local gfs          = require("gears.filesystem")

local theme = {}

-- ── Catppuccin Mocha palette ──────────────────────────────────────────────────
local cp = {
  base      = "#1e1e2e",
  mantle    = "#181825",
  crust     = "#11111b",
  surface0  = "#313244",
  surface1  = "#45475a",
  surface2  = "#585b70",
  overlay0  = "#6c7086",
  overlay1  = "#7f849c",
  overlay2  = "#9399b2",
  subtext0  = "#a6adc8",
  subtext1  = "#bac2de",
  text      = "#cdd6f4",
  lavender  = "#b4befe",
  blue      = "#89b4fa",
  sapphire  = "#74c7ec",
  sky       = "#89dceb",
  teal      = "#94e2d5",
  green     = "#a6e3a1",
  yellow    = "#f9e2af",
  peach     = "#fab387",
  maroon    = "#eba0ac",
  red       = "#f38ba8",
  mauve     = "#cba6f7",
  pink      = "#f5c2e7",
  flamingo  = "#f2cdcd",
  rosewater = "#f5e0dc",
}
theme.cp = cp  -- export so widgets can use it

-- ── Fonts ─────────────────────────────────────────────────────────────────────
theme.font          = "JetBrainsMono Nerd Font 10"
theme.font_bold     = "JetBrainsMono Nerd Font Bold 10"

-- ── Core colours ─────────────────────────────────────────────────────────────
theme.bg_normal     = cp.base
theme.bg_focus      = cp.surface0
theme.bg_urgent     = cp.red
theme.bg_minimize   = cp.mantle
theme.bg_systray    = cp.base

theme.fg_normal     = cp.subtext1
theme.fg_focus      = cp.text
theme.fg_urgent     = cp.base
theme.fg_minimize   = cp.overlay1

-- ── Borders ───────────────────────────────────────────────────────────────────
theme.border_width  = dpi(2)
theme.border_normal = cp.surface0
theme.border_focus  = cp.mauve
theme.border_marked = cp.peach

-- ── Gaps ──────────────────────────────────────────────────────────────────────
theme.useless_gap   = dpi(6)

-- ── Wibar ─────────────────────────────────────────────────────────────────────
theme.wibar_bg      = cp.mantle
theme.wibar_fg      = cp.text
theme.wibar_height  = dpi(32)
theme.wibar_border_color = cp.surface0

-- ── Taglist ───────────────────────────────────────────────────────────────────
theme.taglist_bg_focus    = cp.mauve
theme.taglist_fg_focus    = cp.base
theme.taglist_bg_urgent   = cp.red
theme.taglist_fg_urgent   = cp.base
theme.taglist_bg_occupied = cp.surface1
theme.taglist_fg_occupied = cp.text
theme.taglist_bg_empty    = cp.mantle
theme.taglist_fg_empty    = cp.overlay0
theme.taglist_spacing     = dpi(4)

-- ── Tasklist ──────────────────────────────────────────────────────────────────
theme.tasklist_bg_focus   = cp.surface0
theme.tasklist_fg_focus   = cp.lavender
theme.tasklist_bg_normal  = cp.mantle
theme.tasklist_fg_normal  = cp.subtext1
theme.tasklist_bg_urgent  = cp.red
theme.tasklist_fg_urgent  = cp.base
theme.tasklist_plain_task_name = true

-- ── Titlebars ─────────────────────────────────────────────────────────────────
theme.titlebar_bg_normal  = cp.mantle
theme.titlebar_fg_normal  = cp.overlay1
theme.titlebar_bg_focus   = cp.surface0
theme.titlebar_fg_focus   = cp.text
theme.titlebar_height     = dpi(26)

-- ── Notifications ─────────────────────────────────────────────────────────────
theme.notification_bg       = cp.surface0
theme.notification_fg       = cp.text
theme.notification_border_color = cp.mauve
theme.notification_border_width = dpi(2)
theme.notification_font     = "JetBrainsMono Nerd Font 10"
theme.notification_margin   = dpi(12)
theme.notification_icon_size = dpi(48)

-- ── Menu ──────────────────────────────────────────────────────────────────────
theme.menu_height  = dpi(24)
theme.menu_width   = dpi(180)
theme.menu_bg_normal = cp.surface0
theme.menu_fg_normal = cp.text
theme.menu_bg_focus  = cp.mauve
theme.menu_fg_focus  = cp.base
theme.menu_border_color = cp.surface1
theme.menu_border_width = dpi(1)

-- ── Hotkeys popup ─────────────────────────────────────────────────────────────
theme.hotkeys_bg             = cp.base
theme.hotkeys_fg             = cp.text
theme.hotkeys_border_width   = dpi(2)
theme.hotkeys_border_color   = cp.mauve
theme.hotkeys_modifiers_fg   = cp.mauve
theme.hotkeys_label_bg       = cp.surface0
theme.hotkeys_label_fg       = cp.text
theme.hotkeys_font           = "JetBrainsMono Nerd Font 10"
theme.hotkeys_description_font = "JetBrainsMono Nerd Font 9"
theme.hotkeys_group_margin   = dpi(6)

-- ── Layoutbox icons (generated) ───────────────────────────────────────────────
theme.layout_tile       = theme_assets.layout_tile(cp.text)
theme.layout_tileleft   = theme_assets.layout_tileleft(cp.text)
theme.layout_tilebottom = theme_assets.layout_tilebottom(cp.text)
theme.layout_tiletop    = theme_assets.layout_tiletop(cp.text)
theme.layout_fairv      = theme_assets.layout_fairv(cp.text)
theme.layout_fairh      = theme_assets.layout_fairh(cp.text)
theme.layout_spiral     = theme_assets.layout_spiral(cp.text)
theme.layout_dwindle    = theme_assets.layout_dwindle(cp.text)
theme.layout_max        = theme_assets.layout_max(cp.text)
theme.layout_fullscreen = theme_assets.layout_fullscreen(cp.text)
theme.layout_magnifier  = theme_assets.layout_magnifier(cp.text)
theme.layout_floating   = theme_assets.layout_floating(cp.text)
theme.layout_cornernw   = theme_assets.layout_cornernw(cp.text)
theme.layout_cornerne   = theme_assets.layout_cornerne(cp.text)
theme.layout_cornersw   = theme_assets.layout_cornersw(cp.text)
theme.layout_cornerse   = theme_assets.layout_cornerse(cp.text)

-- ── Taglist squares (tiny indicator dots) ─────────────────────────────────────
local taglist_square_size = dpi(4)
theme.taglist_squares_sel   = theme_assets.taglist_squares_sel(taglist_square_size, cp.text)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, cp.overlay0)

return theme
