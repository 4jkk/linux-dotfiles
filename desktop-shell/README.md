# Desktop Shell

GitHub-ready backup of a combined Quickshell taskbar and control center for
Hyprland and Niri.

## Contents

- `config/quickshell/desktop-shell/` — taskbar, control center, popups,
  widgets, assets, settings, and every font loaded by the shell.
- `config/niri/config.kdl` — the current Niri configuration, including startup
  and key bindings for Desktop Shell.
- `config/hypr/hyprland.conf` — equivalent Hyprland monitors, appearance,
  startup commands, key bindings, media controls, and window rules.
- `config/desktop-shell/` — compositor-independent wallpaper and IPC helpers.
- `config/niri/scripts/` — the control-center and wallpaper helper scripts.
- `install.sh` — restores the shell without overwriting the Niri configuration
  unless explicitly requested.

## Restore

Install Quickshell and your compositor first, then run:

```sh
./install.sh
```

To restore the backed-up Niri configuration too:

```sh
./install.sh --with-niri
```

To install the Hyprland configuration instead:

```sh
./install.sh --with-hyprland
```

Existing files are preserved in a timestamped directory under
`~/.local/state/desktop-shell/`.

Both compositor configurations launch the shell as `quickshell -c
desktop-shell`. Workspace buttons and the active-window title automatically
use `hyprctl` in Hyprland and `niri msg` in Niri.

The Niri launch line is:

```kdl
spawn-at-startup "quickshell" "-c" "desktop-shell"
```

The current settings refer to an avatar and wallpaper under the original
user's `Downloads` and `Pictures` directories. Those personal image files are
not included; select replacements in the shell settings after restoring.

## Runtime tools

Some controls expect `wpctl`, `brightnessctl`, `nmcli`, `bluetoothctl`,
`pavucontrol`, `nemo`, and `kitty`. Weather uses OpenWeatherMap and requires an
API key in `settings.json`.

## Fonts

All fonts loaded by the QML shell are stored in
`config/quickshell/desktop-shell/fonts/`; Quickshell loads them directly,
so no system-wide font installation is required. Check each font's
redistribution terms before making the repository public. In particular,
commercial or system fonts may not permit public redistribution; a private
GitHub repository is the safest backup destination.
