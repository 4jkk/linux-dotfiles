#!/bin/bash

# Power menu options with icons
# Show fuzzel menu and get selection
selected=$(printf "Lock\0icon\x1fsystem-lock-screen,system-lock\nLogout\0icon\x1fsystem-log-out,system-logout\nSuspend\0icon\x1fsystem-suspend,system-sleep\nReboot\0icon\x1fsystem-restart,system-reboot\nShutdown\0icon\x1fsystem-shutdown,system-poweroff" | fuzzel --dmenu --prompt "Power: ")

# Execute based on selection
case $selected in
    Lock)
        hyprlock
        ;;
    Logout)
        hyprctl dispatch exit
        ;;
    Suspend)
        systemctl suspend
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
esac
