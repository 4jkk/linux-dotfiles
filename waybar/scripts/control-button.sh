#!/bin/bash
# Open terminal with control center
exec wezterm --always-new-instance -e bash -c '
echo "=== Control Center ==="
echo "1. Toggle WiFi"
echo "2. Toggle Bluetooth" 
echo "3. Toggle Caffeine"
echo "4. Volume Up"
echo "5. Volume Down"
echo "6. Brightness Up"
echo "7. Brightness Down"
echo "8. Media Play/Pause"
echo "9. Media Next"
echo "10. Media Previous"
echo ""
echo -n "Select: "
read choice

case $choice in
    1) nmcli radio wifi toggle ;;
    2) bluetoothctl power toggle ;;
    3) pgrep -x caffeine >/dev/null && pkill -x caffeine || caffeine & ;;
    4) wpctl set-volume @DEFAULT_AUDIO_SINK@ +5% ;;
    5) wpctl set-volume @DEFAULT_AUDIO_SINK@ -5% ;;
    6) echo $(( $(cat /sys/class/backlight/amdgpu_bl1/brightness) + $(cat /sys/class/backlight/amdgpu_bl1/max_brightness)/20 )) > /sys/class/backlight/amdgpu_bl1/brightness 2>/dev/null || echo "Brightness up" ;;
    7) echo $(( $(cat /sys/class/backlight/amdgpu_bl1/brightness) - $(cat /sys/class/backlight/amdgpu_bl1/max_brightness)/20 )) > /sys/class/backlight/amdgpu_bl1/brightness 2>/dev/null || echo "Brightness down" ;;
    8) playerctl play-pause ;;
    9) playerctl next ;;
    10) playerctl previous ;;
esac

echo ""
echo "Done. Press Enter to exit."
read
'
