#!/usr/bin/env bash
# Install Awesome WM and all supporting packages on Arch Linux
set -euo pipefail

echo "==> Installing core packages via pacman..."
sudo pacman -S --needed --noconfirm \
  awesome \
  picom \
  rofi \
  nitrogen \
  feh \
  xwallpaper \
  network-manager-applet \
  blueman \
  pasystray \
  polkit-gnome \
  brightnessctl \
  playerctl \
  xclip \
  xdotool \
  xorg-xset \
  xorg-setxkbmap \
  curl \
  ttf-jetbrains-mono-nerd

echo "==> Installing AUR packages (requires yay or paru)..."
AUR_HELPER=$(command -v yay || command -v paru || true)

if [ -z "$AUR_HELPER" ]; then
  echo "  WARNING: No AUR helper found. Install yay or paru, then run:"
  echo "    yay -S --needed vicious-git lain-git copyq"
else
  $AUR_HELPER -S --needed --noconfirm \
    vicious \
    lain \
    copyq \
    grimblast-git \
    picom-git        # optional: for animations/blur support
fi

echo "==> Copying config to ~/.config/awesome..."
AWESOMECFG="$HOME/.config/awesome"
mkdir -p "$AWESOMECFG"
cp -r ./* "$AWESOMECFG/"
echo "  Done — config is at $AWESOMECFG"

echo "==> Creating minimal picom config..."
mkdir -p "$HOME/.config/picom"
cat > "$HOME/.config/picom/picom.conf" << 'EOF'
backend = "glx";
vsync = true;

# Shadows — matching Hyprland: range=12, render_power=3, color=0xee1a1a2e
shadow = true;
shadow-radius = 12;
shadow-offset-x = -6;
shadow-offset-y = -6;
shadow-opacity = 0.6;
shadow-color = "#1a1a2e";
shadow-exclude = [
  "class_g = 'awesome'",
  "window_type = 'dock'",
  "window_type = 'desktop'",
];

# Fading — matching Hyprland animations (speed 5, smooth bezier)
fading = true;
fade-in-step  = 0.06;
fade-out-step = 0.06;
fade-delta = 4;

# Opacity — matching Hyprland: active=1.0, inactive=0.95
inactive-opacity = 0.95;
active-opacity   = 1.0;
opacity-rule = [
  "100:class_g = 'firefox'",
  "100:class_g = 'mpv'",
  "100:class_g = 'Alacritty' && focused",
];
inactive-opacity-override = false;

# Rounded corners — matching Hyprland decoration.rounding = 4
corner-radius = 4;
rounded-corners-exclude = [
  "window_type = 'dock'",
  "window_type = 'desktop'",
];

# Blur — matching Hyprland: size=4, passes=2
# Requires picom-git (jonaburg/pijulius fork)
blur-method = "dual_kawase";
blur-strength = 4;
blur-background = true;
blur-background-exclude = [
  "window_type = 'dock'",
  "window_type = 'desktop'",
  "class_g = 'slop'",
];
EOF

echo ""
echo "==> Done! To start Awesome WM:"
echo "    • If using a display manager (SDDM/LightDM): select 'awesome' at login."
echo "    • If using startx: add 'exec awesome' to ~/.xinitrc and run 'startx'."
echo ""
echo "==> First-run tips:"
echo "    • Edit ~/.config/awesome/autostart.lua to match your apps."
echo "    • Edit ~/.config/awesome/rules/rules.lua for per-app tag assignments."
echo "    • Run: awesome-client 'awesome.restart()' to reload config."
