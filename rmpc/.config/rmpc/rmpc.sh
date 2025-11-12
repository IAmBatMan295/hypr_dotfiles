#!/bin/bash

# Detect rmpc process
RMPC_PID=$(pgrep -x rmpc)

# Detect mpd user service state
MPD_ACTIVE=$(systemctl --user is-active mpd.service)

if [ -n "$RMPC_PID" ]; then
  # rmpc running → kill its terminal + stop mpd
  pkill -x kitty
  systemctl --user stop mpd.service
  RMPC_STATE="STOPPED"
  MPD_STATE="STOPPED"

elif [ "$MPD_ACTIVE" = "active" ]; then
  # rmpc not running but mpd is active → stop mpd
  systemctl --user stop mpd.service
  RMPC_STATE="STOPPED"
  MPD_STATE="STOPPED"

else
  # neither running → start mpd and rmpc
  systemctl --user start mpd.service
  kitty -e rmpc &
  RMPC_STATE="RUNNING"
  MPD_STATE="RUNNING"
fi

notify-send "Music Control" "RMPC: $RMPC_STATE | MPD: $MPD_STATE"
