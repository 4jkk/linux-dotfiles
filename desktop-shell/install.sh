#!/bin/sh
set -eu

compositor=${1:-none}
case "$compositor" in
    none|--with-niri|--with-hyprland) ;;
    *) echo "Usage: $0 [--with-niri|--with-hyprland]" >&2; exit 2 ;;
esac

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
state_home=${XDG_STATE_HOME:-"$HOME/.local/state"}
stamp=$(date +%Y%m%d-%H%M%S)
backup_dir="$state_home/desktop-shell/$stamp"

backup_path() {
    source_path=$1
    relative_path=$2
    if [ -e "$source_path" ]; then
        mkdir -p "$backup_dir/$(dirname -- "$relative_path")"
        cp -a "$source_path" "$backup_dir/$relative_path"
    fi
}

shell_target="$config_home/quickshell/desktop-shell"
backup_path "$shell_target" "quickshell/desktop-shell"
mkdir -p "$config_home/quickshell"
rm -rf "$shell_target"
cp -a "$repo_dir/config/quickshell/desktop-shell" "$shell_target"

common_target="$config_home/desktop-shell"
backup_path "$common_target" "desktop-shell"
mkdir -p "$common_target"
for script in apply-wallpaper.sh control-center.sh; do
    cp -a "$repo_dir/config/desktop-shell/$script" "$common_target/$script"
done

mkdir -p "$config_home/niri/scripts"
for script in control-center.sh apply-wallpaper.sh; do
    target="$config_home/niri/scripts/$script"
    backup_path "$target" "niri/scripts/$script"
    cp -a "$repo_dir/config/niri/scripts/$script" "$target"
done

if [ "$compositor" = --with-niri ]; then
    target="$config_home/niri/config.kdl"
    backup_path "$target" "niri/config.kdl"
    cp -a "$repo_dir/config/niri/config.kdl" "$target"
elif [ "$compositor" = --with-hyprland ]; then
    target="$config_home/hypr/hyprland.conf"
    backup_path "$target" "hypr/hyprland.conf"
    mkdir -p "$config_home/hypr"
    cp -a "$repo_dir/config/hypr/hyprland.conf" "$target"
else
    echo 'Niri config was not replaced. Ensure it contains:'
    echo '  spawn-at-startup "quickshell" "-c" "desktop-shell"'
    echo 'For Hyprland, use: ./install.sh --with-hyprland'
fi

if [ -d "$backup_dir" ]; then
    echo "Previous files backed up to: $backup_dir"
fi
echo "Desktop Shell restored to: $shell_target"
