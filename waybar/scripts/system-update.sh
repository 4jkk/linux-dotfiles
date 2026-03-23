#!/usr/bin/env bash
#
# Check for package updates and upgrade them. When run with the "module"
# argument, output the status icon and update counts in JSON format for
# Waybar
#
# Requirements:
# - dnf
# - notify-send (libnotify)
#
# Author: Jesse Mirabel (Fedora port by opencode)
# License: MIT

FG_GREEN="\e[32m"
FG_BLUE="\e[34m"
FG_RESET="\e[39m"

FAILURE=false
DNF_UPD=0

TIMEOUT=30

printf() {
	command printf "$@" >&2
}

check_updates() {
	local dnf_output dnf_status

	dnf_output=$(timeout $TIMEOUT dnf check-update 2>&1)
	dnf_status=$?

	if ((dnf_status == 0)); then
		DNF_UPD=0
	elif ((dnf_status == 100)); then
		DNF_UPD=$(echo "$dnf_output" | grep -c "^[a-zA-Z0-9].*\\." || echo 0)
	else
		FAILURE=true
		return 1
	fi
}

update_packages() {
	printf "%bUpdating packages...%b\n" "$FG_BLUE" "$FG_RESET"
	sudo dnf update -y

	notify-send "Update Complete" -i "package-install"

	printf "\n%bUpdate Complete!%b\n" "$FG_GREEN" "$FG_RESET"
	read -rsn 1 -p "Press any key to exit..."
}

display_module() {
	local icon tooltip

	if $FAILURE; then
		icon='󰒑'
		tooltip="Cannot fetch updates. Right-click to retry."
	elif ((DNF_UPD == 0)); then
		icon='󰸟'
		tooltip="No updates available"
	else
		icon='󰄠'
		tooltip="<b>Updates</b>: $DNF_UPD"
	fi

	command printf '{ "text": "%s", "tooltip": "%s" }\n' "$icon" "$tooltip"
}

main() {
	case $1 in
		module)
			check_updates
			display_module
			;;
		*)
			printf "%bChecking for updates...%b\n" "$FG_BLUE" "$FG_RESET"
			check_updates
			update_packages

			pkill -RTMIN+1 waybar
			;;
	esac
}

main "$@"
