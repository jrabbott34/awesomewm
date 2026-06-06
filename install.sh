#!/usr/bin/env bash
# Arch Linux + Awesome WM install script
# Run this from a live ISO for the base install, or from a booted system
# for the WM/dotfiles setup.
set -euo pipefail

# ── Phase detection ───────────────────────────────────────────────────────────
# If /mnt is mounted (live ISO), run the full Arch base install first.
# If we're already inside a booted Arch system, skip straight to WM setup.
if mountpoint -q /mnt 2>/dev/null && [ -d /mnt/etc ]; then
  PHASE="pacstrap"
else
  PHASE="wm"
fi

# ─────────────────────────────────────────────────────────────────────────────
# PHASE 1 — Base system (run from live ISO after partitioning/mounting)
# ─────────────────────────────────────────────────────────────────────────────
if [ "$PHASE" = "pacstrap" ]; then
  echo "==> [Phase 1] Base Arch install via pacstrap..."
  echo "    Make sure /mnt is already partitioned, formatted, and mounted."
  read -rp "    Continue? [y/N] " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }

  pacstrap /mnt \
    base base-devel linux linux-firmware \
    networkmanager git sudo \
    xorg xorg-xinit xorg-server \
    pipewire pipewire-pulse wireplumber \
    alsa-utils \
    grub efibootmgr \
    vim nano

  echo "==> Generating fstab..."
  genfstab -U /mnt >> /mnt/etc/fstab

  echo ""
  echo "==> Base install complete. Next steps:"
  echo "    1. arch-chroot /mnt"
  echo "    2. Set timezone, locale, hostname, root password, create user"
  echo "    3. grub-install && grub-mkconfig -o /boot/grub/grub.cfg"
  echo "    4. systemctl enable NetworkManager"
  echo "    5. Reboot, log in as your user, clone this repo, run install.sh again"
  exit 0
fi

# ─────────────────────────────────────────────────────────────────────────────
# PHASE 2 — WM, dotfiles, SDDM (run from booted Arch as your normal user)
# ─────────────────────────────────────────────────────────────────────────────
echo "==> [Phase 2] Installing Awesome WM and supporting packages..."

sudo pacman -S --needed --noconfirm \
  awesome \
  picom \
  rofi \
  nitrogen \
  feh \
  xwallpaper \
  xautolock \
  network-manager-applet \
  blueman \
  pasystray \
  polkit-gnome \
  brightnessctl \
  playerctl \
  xclip \
  xdotool \
  maim \
  xorg-xset \
  xorg-setxkbmap \
  dunst \
  alacritty \
  thunar \
  firefox \
  curl \
  jq \
  ttf-firacode-nerd \
  sddm \
  qt5-graphicaleffects \
  qt5-quickcontrols2 \
  qt5-svg

# ── AUR packages ──────────────────────────────────────────────────────────────
echo "==> Installing AUR packages..."
AUR_HELPER=$(command -v yay || command -v paru || true)

if [ -z "$AUR_HELPER" ]; then
  echo "  No AUR helper found — installing yay..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
  AUR_HELPER="yay"
fi

$AUR_HELPER -S --needed --noconfirm \
  vicious \
  lain \
  picom-git \
  sddm-catppuccin-git

# ── Dotfiles ──────────────────────────────────────────────────────────────────
echo "==> Deploying Awesome WM config to ~/.config/awesome..."
AWESOMECFG="$HOME/.config/awesome"
mkdir -p "$AWESOMECFG"
# Copy everything except the install script and README
rsync -av --exclude='install.sh' --exclude='README.md' --exclude='.git' \
  ./ "$AWESOMECFG/"
echo "  Config deployed to $AWESOMECFG"

# ── xinitrc fallback ──────────────────────────────────────────────────────────
if [ ! -f "$HOME/.xinitrc" ]; then
  echo "exec awesome" > "$HOME/.xinitrc"
  echo "  Created ~/.xinitrc with 'exec awesome'"
fi

# ── picom config ──────────────────────────────────────────────────────────────
echo "==> Writing picom config..."
mkdir -p "$HOME/.config/picom"
cat > "$HOME/.config/picom/picom.conf" << 'PICOMEOF'
backend = "glx";
vsync = true;

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

fading = true;
fade-in-step  = 0.06;
fade-out-step = 0.06;
fade-delta = 4;

inactive-opacity = 0.95;
active-opacity   = 1.0;
opacity-rule = [
  "100:class_g = 'firefox'",
  "100:class_g = 'mpv'",
  "100:class_g = 'Alacritty' && focused",
];
inactive-opacity-override = false;

corner-radius = 4;
rounded-corners-exclude = [
  "window_type = 'dock'",
  "window_type = 'desktop'",
];

blur-method = "dual_kawase";
blur-strength = 4;
blur-background = true;
blur-background-exclude = [
  "window_type = 'dock'",
  "window_type = 'desktop'",
  "class_g = 'slop'",
];
PICOMEOF

# ── SDDM — Catppuccin Mocha theme ─────────────────────────────────────────────
echo "==> Configuring SDDM with Catppuccin Mocha theme..."

sudo mkdir -p /etc/sddm.conf.d

# sddm-catppuccin-git installs to /usr/share/sddm/themes/catppuccin-mocha
# If the AUR package used a different name, adjust Theme= below.
sudo tee /etc/sddm.conf.d/theme.conf > /dev/null << 'SDDMEOF'
[Theme]
Current=catppuccin-mocha

[General]
HideUsers=false
Numlock=on
SDDMEOF

# Patch the theme's theme.conf to set our font and hide the user list border
THEME_DIR="/usr/share/sddm/themes/catppuccin-mocha"
if [ -f "$THEME_DIR/theme.conf" ]; then
  sudo sed -i \
    -e 's/^Font=.*/Font=FiraCode Nerd Font/' \
    -e 's/^FontSize=.*/FontSize=12/' \
    "$THEME_DIR/theme.conf" 2>/dev/null || true
  echo "  Patched $THEME_DIR/theme.conf"
fi

# Point SDDM at a background — reuse whatever feh/nitrogen will set,
# or drop a wallpaper at ~/Pictures/wallpaper.jpg first.
WALLPAPER="$HOME/Pictures/wallpaper.jpg"
if [ -f "$WALLPAPER" ] && [ -f "$THEME_DIR/theme.conf" ]; then
  sudo cp "$WALLPAPER" "$THEME_DIR/backgrounds/wallpaper.jpg" 2>/dev/null || true
  sudo sed -i "s|^Background=.*|Background=\"backgrounds/wallpaper.jpg\"|" \
    "$THEME_DIR/theme.conf" 2>/dev/null || true
  echo "  Wallpaper set in SDDM theme"
fi

# Enable and start SDDM
sudo systemctl enable sddm
echo "  SDDM enabled (will start on next boot)"

# ── Screenshots directory ──────────────────────────────────────────────────────
mkdir -p "$HOME/Pictures/screenshots"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "══════════════════════════════════════════════════════"
echo "  All done!"
echo "══════════════════════════════════════════════════════"
echo ""
echo "  Config:    ~/.config/awesome/"
echo "  picom:     ~/.config/picom/picom.conf"
echo "  SDDM:      /etc/sddm.conf.d/theme.conf  (Catppuccin Mocha)"
echo ""
echo "  Next steps:"
echo "  1. Drop a wallpaper at ~/Pictures/wallpaper.jpg"
echo "  2. Edit ~/.config/awesome/autostart.lua if needed"
echo "  3. Reboot → SDDM will greet you, select 'awesome'"
echo ""
echo "  To reload Awesome without rebooting:"
echo "    awesome-client 'awesome.restart()'"
echo "  Or:  Super + Ctrl + R"
echo ""
