#!/bin/bash
options="  Shutdown\n  Reboot\n󰍃  Logout\n  Lock"
choice=$(printf "$options" | fuzzel --dmenu --prompt ">" --lines 4)

case "$choice" in
  Shutdown) systemctl poweroff ;;
  Reboot) systemctl reboot ;;
  Logout) niri msg exit ;;
  Lock) loginctl lock-session ;;
esac