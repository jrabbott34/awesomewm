-- Autostart — ported from hyprland.lua's hl.on("hyprland.start", ...) block
-- X11 equivalents used where Wayland-specific tools can't apply
local awful = require("awful")
local gears = require("gears")

local function run_once(cmd)
  local name = cmd:match("^%S+"):match("[^/]+$")
  awful.spawn.with_shell(string.format("pgrep -u $USER -x '%s' > /dev/null || %s", name, cmd))
end

-- ── Compositor — replaces Hyprland's built-in compositor ─────────────────────
-- picom handles shadows, blur (picom-git), rounded corners, inactive opacity
run_once("picom --config ~/.config/picom/picom.conf")

-- ── Auth agent (same as Hyprland) ─────────────────────────────────────────────
run_once("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

-- ── Status bar — Awesome has its own wibar, waybar not needed ─────────────────
-- (waybar is intentionally omitted; use the built-in wibar in rc.lua)

-- ── Notification daemon (same as Hyprland) ───────────────────────────────────
run_once("dunst")

-- ── Wallpaper — waypaper is Wayland-only; feh/nitrogen work on X11 ──────────
-- Restore last wallpaper set by feh (equivalent to waypaper --restore):
awful.spawn.with_shell("~/.fehbg 2>/dev/null || feh --bg-fill ~/Pictures/wallpaper.jpg 2>/dev/null || true")

-- ── Idle / screen lock — hypridle is Wayland-only ───────────────────────────
-- Use xautolock as the X11 equivalent of hypridle:
-- Locks after 10 min idle, dims after 9 min (optional)
run_once("xautolock -time 10 -locker 'i3lock -c 1e1e2e' -notify 60 -notifier 'notify-send Idle \"Locking in 60s\"'")

-- ── Network / Bluetooth (same as Hyprland) ────────────────────────────────────
run_once("nm-applet --indicator")
run_once("blueman-applet")

-- ── XDG portals — less critical on X11 but harmless ─────────────────────────
-- run_once("/usr/lib/xdg-desktop-portal-gtk")

-- ── Login sound (same as Hyprland) ───────────────────────────────────────────
awful.spawn.with_shell(
  "sleep 2 && paplay ~/.config/hypr/sounds/login.ogg 2>/dev/null || " ..
  "paplay /usr/share/sounds/freedesktop/stereo/service-login.oga 2>/dev/null || true")

-- ── Input settings — kb_layout us, sensitivity 0, key repeat ─────────────────
-- Mirrors Hyprland's input { kb_layout = "us", ... }
awful.spawn.with_shell("setxkbmap -layout us")
-- Key repeat: delay 300ms at 50Hz (adjust to taste)
awful.spawn.with_shell("xset r rate 300 50")
-- Cursor size (XCURSOR_SIZE = 24 from Hyprland env)
awful.spawn.with_shell("xsetroot -cursor_name left_ptr")

-- ── Clipboard manager ─────────────────────────────────────────────────────────
-- run_once("copyq")
