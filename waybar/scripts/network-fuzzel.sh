#!/usr/bin/env bash
#
# Scan, select, and connect to Wi-Fi networks using fuzzel
#
# Requirements:
# - nmcli (networkmanager)
# - fuzzel
# - notify-send (libnotify)

FG_RED="\e[31m"
FG_RESET="\e[39m"

TIMEOUT=5

printf() {
	command printf "$@" >&2
}

switch_on() {
	local state
	state=$(nmcli radio wifi)

	if [[ $state == enabled ]]; then
		return 0
	fi

	nmcli radio wifi on

	local new_state

	local i=1
	for ((; i <= TIMEOUT; i++)); do
		printf "\rEnabling Wi-Fi... (%d/%d)" $i $TIMEOUT

		new_state=$(nmcli -t -f STATE general)
		if [[ $new_state != "connected (local only)" ]]; then
			break
		fi

		sleep 1
	done

	notify-send "Wi-Fi Enabled" -i "network-wireless-on" \
		-h string:x-canonical-private-synchronous:network
}

get_networks() {
	nmcli device wifi rescan

	local i=1
	for ((; i <= TIMEOUT; i++)); do
		printf "\rScanning for networks... (%d/%d)" $i $TIMEOUT

		LIST=$(timeout 1 nmcli device wifi list)
		NETWORKS=$(tail -n +2 <<< "$LIST" | awk '$2 != "--"')

		if [[ -n $NETWORKS ]]; then
			break
		fi
	done

	printf "\n%bScanning stopped.%b\n\n" "$FG_RED" "$FG_RESET"

	if [[ -z $NETWORKS ]]; then
		notify-send "Wi-Fi" "No networks found" -i "package-broken"
		exit 1
	fi
}

select_network() {
	local names
	names=$(awk '{print $NF}' <<< "$NETWORKS")

	local selected
	selected=$(fuzzel -d -w 50 --border=sharp --border-label=" Wi-Fi " <<< "$names")

	if [[ -z $selected ]]; then
		exit 1
	fi

	BSSID=$(awk -v sel="$selected" '$NF == sel {print $1; exit}' <<< "$NETWORKS")

	if [[ -z $BSSID ]]; then
		notify-send "Wi-Fi" "Invalid selection" -i "package-broken"
		exit 1
	fi
}

connect() {
	printf "Connecting...\n"

	if ! nmcli -a device wifi connect "$BSSID"; then
		notify-send "Wi-Fi" "Failed to connect" -i "package-purge"
		exit 1
	fi

	notify-send "Wi-Fi" "Successfully connected" -i "package-install"
}

main() {
	switch_on
	get_networks
	select_network
	connect
}

main
