#!/bin/sh
set -eu

SETTINGS_FILE="$HOME/.config/quickshell/desktop-shell/settings.json"

wallpaper="${1:-}"
if [ -z "$wallpaper" ] && [ -f "$SETTINGS_FILE" ]; then
    wallpaper=$(jq -r '.settings.ui.wallpaperPath // empty' "$SETTINGS_FILE")
fi

if [ -z "$wallpaper" ] || [ "$wallpaper" = "null" ] || [ ! -f "$wallpaper" ]; then
    exit 0
fi

if ! command -v swaybg >/dev/null 2>&1; then
    exit 1
fi

pkill -x swaybg 2>/dev/null || true
nohup swaybg -i "$wallpaper" -m fill </dev/null >/dev/null 2>&1 &
