#!/bin/bash
# A power menu script using Fuzzel and Hyprlock

# Define icons
LOCK=" Lock"
LOGOUT=" Logout"
RESTART=" Restart"
SHUTDOWN=" Shutdown"

# Get user choice
# We use fuzzel in dmenu mode, with a prompt
selected=$(echo -e "$LOCK\n$LOGOUT\n$RESTART\n$SHUTDOWN" | fuzzel \
    --dmenu \
    --prompt=" " \
    --lines=4 \
    --width=20)

# Execute action
case "$selected" in
    "$LOCK")
        hyprlock
        ;;
    "$LOGOUT")
        # This will exit Hyprland and return you to SDDM, which is correct.
        hyprctl dispatch exit
        ;;
    "$RESTART")
        systemctl reboot
        ;;
    "$SHUTDOWN")
        systemctl poweroff
        ;;
esac
