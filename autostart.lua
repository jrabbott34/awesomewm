-- Autostart — runs once on awesome startup/restart
local awful = require("awful")

local function run_once(cmd)
  -- Only spawn if not already running
  local find = string.format("pgrep -u $USER -x '%s' > /dev/null", cmd:match("^%S+"):match("[^/]+$"))
  awful.spawn.with_shell(find .. " || " .. cmd)
end

-- ── Compositor ────────────────────────────────────────────────────────────────
-- picom provides shadows, transparency, and rounded corners
run_once("picom --config ~/.config/picom/picom.conf")

-- ── System tray helpers ───────────────────────────────────────────────────────
run_once("nm-applet")                           -- NetworkManager tray icon
run_once("blueman-applet")                      -- Bluetooth tray icon
run_once("pasystray")                           -- PulseAudio/PipeWire tray icon
run_once("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

-- ── Wallpaper ─────────────────────────────────────────────────────────────────
-- Uncomment and point at your wallpaper:
-- awful.spawn.with_shell("feh --bg-fill ~/Pictures/wallpaper.jpg")
-- OR: awful.spawn.with_shell("nitrogen --restore")
awful.spawn.with_shell("xwallpaper --zoom ~/Pictures/wallpaper.jpg 2>/dev/null || true")

-- ── Input (XKB) ───────────────────────────────────────────────────────────────
-- Set keyboard layout / repeat rate to match your Hyprland input block
awful.spawn.with_shell("setxkbmap -layout us -option caps:escape")
awful.spawn.with_shell("xset r rate 300 50")    -- repeat delay 300ms, 50Hz

-- ── Clipboard manager ─────────────────────────────────────────────────────────
run_once("copyq")

-- ── Notification daemon ───────────────────────────────────────────────────────
-- If you use dunst/mako/swaync (as a standalone daemon):
-- run_once("dunst")

-- ── Other apps you want at login ─────────────────────────────────────────────
-- run_once("syncthing --no-browser")
-- run_once("nextcloud")
