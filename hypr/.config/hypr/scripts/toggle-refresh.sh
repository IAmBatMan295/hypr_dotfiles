#!/usr/bin/env bash

# Fetch current vrr state (0 = off, 1 = on, 2 = fullscreen)
# Using hyprctl getoption to determine current state
STATE=$(hyprctl getoption misc:vrr -j | grep '"int": 0')

if [ -n "$STATE" ]; then
    # Currently 0 (off, 60Hz locked). Switch to 120Hz VRR.
    hyprctl keyword monitor "eDP-1,2880x1800@120,auto,1.8"
    hyprctl keyword misc:vrr 2
    notify-send "Screen Mode" "120Hz VRR"
else
    # Currently VRR is active. Switch to 60Hz Locked.
    hyprctl keyword monitor "eDP-1,2880x1800@60,auto,1.8"
    hyprctl keyword misc:vrr 0
    notify-send "Screen Mode" "60Hz Locked"
fi
