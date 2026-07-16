#!/bin/sh
set -eu

settings_file="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/desktop-shell/settings.json"
wallpaper=${1:-}

if [ -z "$wallpaper" ] && [ -f "$settings_file" ]; then
    wallpaper=$(jq -r '.settings.ui.wallpaperPath // empty' "$settings_file")
fi

if [ -z "$wallpaper" ] || [ "$wallpaper" = null ] || [ ! -f "$wallpaper" ]; then
    exit 0
fi

command -v swaybg >/dev/null 2>&1 || exit 1
pkill -x swaybg 2>/dev/null || true
nohup swaybg -i "$wallpaper" -m fill </dev/null >/dev/null 2>&1 &

