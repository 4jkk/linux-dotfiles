#!/usr/bin/env bash

set -u

TIMEOUT=10

notify() {
    notify-send "Bluetooth" "$1" -h string:x-canonical-private-synchronous:bluetooth 2>/dev/null || true
}

power_on() {
    local state
    state=$(bluetoothctl show 2>/dev/null | awk -F': ' '/Powered/ {print $2; exit} /PowerState/ {print $2; exit}')

    if [ "$state" = "yes" ] || [ "$state" = "on" ]; then
        return 0
    fi

    rfkill unblock bluetooth 2>/dev/null || true
    bluetoothctl power on >/dev/null 2>&1 || true

    for _ in $(seq 1 "$TIMEOUT"); do
        state=$(bluetoothctl show 2>/dev/null | awk -F': ' '/Powered/ {print $2; exit} /PowerState/ {print $2; exit}')
        if [ "$state" = "yes" ] || [ "$state" = "on" ]; then
            return 0
        fi
        sleep 1
    done

    notify "Could not power on the adapter"
    exit 1
}

device_name() {
    bluetoothctl info "$1" 2>/dev/null | awk -F': ' '/Name/ {print $2; exit}'
}

device_connected() {
    bluetoothctl info "$1" 2>/dev/null | awk -F': ' '/Connected/ {print $2; exit}'
}

device_paired() {
    bluetoothctl info "$1" 2>/dev/null | awk -F': ' '/Paired/ {print $2; exit}'
}

build_menu() {
    local devices address name connected icon

    devices=$(bluetoothctl devices 2>/dev/null | sed -E $'s/\x1B\\[[0-9;]*[mK]//g; s/^Device //')
    if [ -z "$devices" ]; then
        return 1
    fi

    while read -r address name; do
        [ -n "${address:-}" ] || continue
        name=$(device_name "$address")
        [ -n "$name" ] || name="$address"

        connected=$(device_connected "$address")
        icon="󰂯"
        [ "$connected" = "yes" ] && icon="󰂱"

        printf '%s %s\t%s\n' "$icon" "$name" "$address"
    done <<< "$devices"
}

select_device() {
    local menu selected

    menu=$(build_menu) || {
        notify "No devices found"
        exit 1
    }

    selected=$(printf '%s\n' "$menu" | cut -f1 | fuzzel --dmenu --prompt="Bluetooth: " --lines=12)
    [ -n "$selected" ] || exit 0

    printf '%s\n' "$menu" | awk -F'\t' -v selected="$selected" '$1 == selected {print $2; exit}'
}

connect_device() {
    local address=$1
    local name paired connected

    name=$(device_name "$address")
    [ -n "$name" ] || name="$address"

    connected=$(device_connected "$address")
    if [ "$connected" = "yes" ]; then
        notify "$name is already connected"
        exit 0
    fi

    paired=$(device_paired "$address")
    if [ "$paired" != "yes" ]; then
        bluetoothctl pair "$address" >/dev/null 2>&1 || {
            notify "Could not pair $name"
            exit 1
        }
        bluetoothctl trust "$address" >/dev/null 2>&1 || true
    fi

    bluetoothctl connect "$address" >/dev/null 2>&1 && notify "Connected to $name" && exit 0

    notify "Could not connect $name"
    exit 1
}

main() {
    power_on
    notify "Scanning for devices..."
    bluetoothctl -t "$TIMEOUT" scan on >/dev/null 2>&1 || true

    local address
    address=$(select_device)
    [ -n "$address" ] || exit 0
    connect_device "$address"
}

main "$@"
