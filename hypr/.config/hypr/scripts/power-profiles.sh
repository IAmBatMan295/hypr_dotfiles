#!/usr/bin/env bash

active=$(powerprofilesctl get)

c_perf="#8e8e8e"
c_bal="#8e8e8e"
c_save="#8e8e8e"

[[ "$active" == "performance" ]] && c_perf="#ffffff"
[[ "$active" == "balanced" ]] && c_bal="#ffffff"
[[ "$active" == "power-saver" ]] && c_save="#ffffff"

PERF="<span color=\"$c_perf\">  Performance</span>"
BAL="<span color=\"$c_bal\">  Balanced</span>"
SAVE="<span color=\"$c_save\">󰤄  Power Saver</span>"

rofi_cmd() {
  rofi -dmenu \
    -p "Profile ($active)" \
    -markup-rows \
    -theme-str 'listview { lines: 3; }' \
    -theme ~/.config/rofi/powermenu.rasi
}

run_rofi() {
  echo -e "$PERF\n$BAL\n$SAVE" | rofi_cmd
}

run_cmd() {
  case $1 in
  --performance)
    powerprofilesctl set performance
    notify-send -t 3000 "Power Profile" "Set to  Performance Mode"
    ;;
  --balanced)
    powerprofilesctl set balanced
    notify-send -t 3000 "Power Profile" "Set to   Balanced Mode"
    ;;
  --power-saver)
    powerprofilesctl set power-saver
    notify-send -t 3000 "Power Profile" "Set to 󰤄 Power Saver Mode"
    
    STATE=$(hyprctl getoption misc:vrr -j | grep '"int": 0')
    if [ -z "$STATE" ]; then
        hyprctl keyword monitor "eDP-1,2880x1800@60,auto,1.8"
        hyprctl keyword misc:vrr 0
        notify-send -t 4000 "Power Saver Active" "Refresh rate locked to 60Hz"
    fi
    ;;
  esac
}

chosen="$(run_rofi)"

case "$chosen" in
	*"Performance"*)
	  run_cmd --performance
	  ;;
	*"Balanced"*)
	  run_cmd --balanced
	  ;;
	*"Power Saver"*)
	  run_cmd --power-saver
	  ;;
esac
