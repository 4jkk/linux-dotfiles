#!/usr/bin/env bash

STATE_FILE="/tmp/waybar-tray-toggle.state"

if [[ ! -f "$STATE_FILE" ]]; then
    echo "collapsed" > "$STATE_FILE"
fi

state=$(cat "$STATE_FILE")

if [[ "$state" == "collapsed" ]]; then
    echo "expanded" > "$STATE_FILE"
else
    echo "collapsed" > "$STATE_FILE"
fi

pkill -SIGUSR1 waybar
