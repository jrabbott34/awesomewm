# Awesome WM — Catppuccin Mocha

Modular Awesome WM configuration targeting parity with a Hyprland/Sway workflow.

## Structure

```
~/.config/awesome/
├── rc.lua              ← entry point, wibar, signals
├── autostart.lua       ← apps launched at startup
├── theme/
│   └── theme.lua       ← Catppuccin Mocha colours, fonts, borders, gaps
├── keys/
│   └── keybindings.lua ← all global + client keybinds
├── rules/
│   └── rules.lua       ← window rules + tag assignments
└── widgets/
    ├── init.lua
    ├── cpu.lua
    ├── ram.lua
    ├── volume.lua
    ├── wifi.lua
    ├── battery.lua
    └── btc.lua
```

## Quick install

```bash
chmod +x install.sh && ./install.sh
```

## Key dependencies

| Package | Source | Purpose |
|---------|--------|---------|
| `awesome` | pacman | WM |
| `vicious` | AUR | CPU/RAM widgets |
| `picom` | pacman/AUR | Compositor (shadows, blur, rounded corners) |
| `rofi` | pacman | App launcher |
| `ttf-jetbrains-mono-nerd` | pacman | Font with glyphs |
| `playerctl` | pacman | Media keys |
| `brightnessctl` | pacman | Brightness keys |

## Modifier key

`Super` (Mod4) — same as Hyprland/Sway default.

## Default tags (workspaces)

| # | Icon | Intended use |
|---|------|-------------|
| 1 | 󰣇 | Terminal / dev |
| 2 | 󰈹 | Browser |
| 3 | 󰭹 | Chat |
| 4 | 󰙨 | Git / code |
| 5 | 󰎆 | Music |
| 6 | 󰏘 | Art / design |
| 7 | 󰃲 | Calendar |
| 8 | 󰋊 | Files |
| 9 | 󰿎 | Misc |
