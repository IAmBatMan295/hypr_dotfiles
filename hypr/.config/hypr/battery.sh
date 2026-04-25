#!/bin/bash

while true; do
  # Adjust BAT0 if your battery ID differs (check /sys/class/power_supply/)
  bat_lvl=$(cat /sys/class/power_supply/BAT0/capacity)
  bat_status=$(cat /sys/class/power_supply/BAT0/status)

  if [ "$bat_status" = "Discharging" ]; then
    # Critical Battery at 15% or below
    if [ "$bat_lvl" -le 15 ] && [ ! -f /tmp/bat_crit_sent ]; then
      pw-play /usr/share/sounds/freedesktop/stereo/suspend-error.oga &
      notify-send -u critical -h string:x-canonical-private-synchronous:battery "  Battery Level is Critical !!"
      touch /tmp/bat_crit_sent

    # Low Battery at 30% or below (but above 15%)
    elif [ "$bat_lvl" -le 30 ] && [ "$bat_lvl" -gt 15 ] && [ ! -f /tmp/bat_low_sent ]; then
      pw-play /usr/share/sounds/freedesktop/stereo/suspend-error.oga &
      notify-send -u critical -h string:x-canonical-private-synchronous:battery "  Battery Level is Low !!"
      touch /tmp/bat_low_sent
    fi
  else
    # Reset flags when charging - notifications will trigger again on unplug
    rm -f /tmp/bat_crit_sent /tmp/bat_low_sent
  fi
  sleep 30
done
