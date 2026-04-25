#!/usr/bin/env bash

LOCK="  Lock"
LOGOUT="  Logout"
RESTART="  Reboot"
SHUTDOWN="  Shutdown"

rofi_cmd() {
  rofi -dmenu \
    -theme ~/.config/rofi/powermenu.rasi
}

run_rofi() {
  # order preserved exactly as in original: lock → logout → restart → shutdown
  echo -e "$LOCK\n$LOGOUT\n$RESTART\n$SHUTDOWN" | rofi_cmd
}

run_cmd() {
  case $1 in
  --shutdown)
    systemctl poweroff
    ;;
  --restart)
    systemctl reboot
    ;;
  --logout)
    hyprctl dispatch exit
    ;;
  --lock)
    sleep 0.2
    hyprlock
    ;;
  esac
}

chosen="$(run_rofi)"

case $chosen in
$SHUTDOWN)
  run_cmd --shutdown
  ;;
$RESTART)
  run_cmd --restart
  ;;
$LOGOUT)
  run_cmd --logout
  ;;
$LOCK)
  run_cmd --lock
  ;;
esac

