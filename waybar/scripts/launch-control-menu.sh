#!/usr/bin/env bash
#
# Control Center Menu using Fuzzel
# Shows WiFi, Bluetooth, Caffeine toggles, network scanning, and media controls
#

TERMINAL="${TERMINAL:-wezterm}"
TERM_OPTS="--always-new-instance"

# Brightness control (fallback if brightnessctl not available)
brightness_change() {
    local direction=$1
    local backlight="/sys/class/backlight/amdgpu_bl1"
    
    if [ -f "$backlight/brightness" ]; then
        local max=$(cat "$backlight/max_brightness" 2>/dev/null || echo 255)
        local current=$(cat "$backlight/brightness" 2>/dev/null || echo 128)
        
        if [ "$direction" = "up" ]; then
            local new=$((current + max/20))
            [ $new -gt $max ] && new=$max
        else
            local new=$((current - max/20))
            [ $new -lt 0 ] && new=0
        fi
        
        # Try without sudo first (may work if in video group)
        echo $new > "$backlight/brightness" 2>/dev/null || \
            pkexec bash -c "echo $new > $backlight/brightness" 2>/dev/null || true
    fi
}

get_brightness() {
    local backlight="/sys/class/backlight/amdgpu_bl1"
    if [ -f "$backlight/brightness" ]; then
        local max=$(cat "$backlight/max_brightness" 2>/dev/null || echo 255)
        local current=$(cat "$backlight/brightness" 2>/dev/null || echo 128)
        echo $((current * 100 / max))
    else
        echo "50"
    fi
}

show_wifi_menu() {
    # Get current WiFi status
    wifi_status=$(nmcli -t -f WIFI g 2>/dev/null || echo "disabled")
    
    if [ "$wifi_status" != "enabled" ]; then
        nmcli radio wifi on
        sleep 1
    fi
    
    # Scan for WiFi networks
    nmcli device wifi rescan 2>/dev/null
    sleep 2
    
    # Get list of available networks
    local networks
    networks=$(nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list | grep -v '^--' | head -15)
    
    # Build menu options
    local opts=()
    opts+=("Rescan Networks 󰤨")
    
    # Parse networks and add to menu
    while IFS=: read -r ssid signal security; do
        if [ -n "$ssid" ]; then
            local icon="󰤯"
            [ "$security" != "--" ] && icon="󰤰"
            [ "$signal" -gt 70 ] && icon="󰤨"
            [ "$signal" -gt 50 ] && icon="󰤥"
            [ "$signal" -gt 30 ] && icon="󰤢"
            [ "$signal" -gt 10 ] && icon="󰤟"
            opts+=("$icon $ssid ($signal%)")
        fi
    done <<< "$networks"
    
    opts+=("Open WiFi Settings 󰒈")
    opts+=("Back 󰨎")
    
    local selected
    selected=$(printf "%s\n" "${opts[@]}" | fuzzel --dmenu --prompt="WiFi: " --lines=12)
    
    case "$selected" in
        "Rescan"*)
            show_wifi_menu
            ;;
        "Open WiFi"*)
            $TERMINAL $TERM_OPTS nmtui &
            ;;
        "Back"*)
            main
            ;;
        *)
            # Extract SSID from selection
            local ssid
            ssid=$(echo "$selected" | sed 's/.* \([^ ]*\) (.*/\1/')
            if [ -n "$ssid" ]; then
                # Try to connect (will prompt for password if needed)
                nmcli device wifi connect "$ssid" 2>&1 || (
                    # If requires password, use nmtui
                    $TERMINAL $TERM_OPTS -e nmtui-connect
                )
            fi
            ;;
    esac
}

show_bluetooth_menu() {
    # Get current Bluetooth status
    bt_status=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')
    
    if [ "$bt_status" != "yes" ]; then
        bluetoothctl power on
        sleep 1
    fi
    
    # Get list of available devices
    local devices
    devices=$(bluetoothctl devices | head -15)
    
    # Build menu options
    local opts=()
    opts+=("Scan for Devices 󰤨")
    opts+=("Open Bluetoothctl 󰒈")
    
    # Parse devices and add to menu
    while read -r _ address name; do
        if [ -n "$name" ]; then
            opts+=("󰂯 $name")
        fi
    done <<< "$devices"
    
    opts+=("Back 󰨎")
    
    local selected
    selected=$(printf "%s\n" "${opts[@]}" | fuzzel --dmenu --prompt="Bluetooth: " --lines=12)
    
    case "$selected" in
        "Scan"*)
            bluetoothctl scan on
            sleep 3
            show_bluetooth_menu
            ;;
        "Open Bluetoothctl"*)
            $TERMINAL $TERM_OPTS bluetoothctl &
            ;;
        "Back"*)
            main
            ;;
        *)
            # Extract address and connect
            local address
            address=$(bluetoothctl devices | grep "$selected" | awk '{print $2}')
            if [ -n "$address" ]; then
                bluetoothctl connect "$address"
            fi
            ;;
    esac
}

main() {
    # Get current status
    wifi_status=$(nmcli -t -f WIFI g 2>/dev/null || echo "disabled")
    bt_status=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}' || echo "no")
    caffeine_status=$(pgrep -x caffeine >/dev/null && echo "on" || echo "off")
    
    # Build menu options based on status
    local opts=()
    
    # WiFi section
    if [ "$wifi_status" = "enabled" ]; then
        local ssid
        ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)
        opts+=("WiFi: $ssid 󰤨")
    else
        opts+=("WiFi: Off 󰤯")
    fi
    opts+=("WiFi Networks 󰤲")
    
    # Bluetooth section
    if [ "$bt_status" = "yes" ]; then
        opts+=("Bluetooth: On 󰂯")
    else
        opts+=("Bluetooth: Off 󰂲")
    fi
    opts+=("Bluetooth Devices 󰂱")
    
    # Caffeine toggle
    if [ "$caffeine_status" = "on" ]; then
        opts+=("Caffeine: ON 󰛿")
    else
        opts+=("Caffeine: OFF 󰛿")
    fi
    
    opts+=("---")
    
    # Volume
    local volume
    volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%d", $2*100}')
    opts+=("Volume: $volume% 󰕾")
    
    # Brightness
    local brightness
    brightness=$(get_brightness)
    opts+=("Brightness: $brightness% 󰛨")
    
    opts+=("---")
    
    # Media
    opts+=("Media Play/Pause 󰐊")
    opts+=("Media Next 󰒭")
    opts+=("Media Previous 󰒮")
    
    opts+=("---")
    
    # Quick launch
    opts+=("Open Terminal 󰞷")
    opts+=("Open File Manager 󰤩")
    
    # Show fuzzel menu
    local selected
    selected=$(printf "%s\n" "${opts[@]}" | fuzzel --dmenu --prompt="Control: " --lines=15)
    
    case "$selected" in
        "WiFi:"*)
            nmcli radio wifi toggle
            main
            ;;
        "WiFi Networks"*)
            show_wifi_menu
            ;;
        "Bluetooth:"*)
            bluetoothctl power toggle
            main
            ;;
        "Bluetooth Devices"*)
            show_bluetooth_menu
            ;;
        "Caffeine:"*)
            if [ "$caffeine_status" = "on" ]; then
                pkill -x caffeine
            else
                caffeine &
            fi
            ;;
        "Volume:"*)
            wpctl set-volume @DEFAULT_AUDIO_SINK@ +5%
            main
            ;;
        "Brightness:"*)
            brightness_change up
            main
            ;;
        "Media Play/Pause"*)
            playerctl play-pause
            main
            ;;
        "Media Next"*)
            playerctl next
            main
            ;;
        "Media Previous"*)
            playerctl previous
            main
            ;;
        "Open Terminal"*)
            $TERMINAL $TERM_OPTS &
            ;;
        "Open File Manager"*)
            nautilus &
            ;;
    esac
}

main "$@"
