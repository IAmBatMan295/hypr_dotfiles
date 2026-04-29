#!/usr/bin/env bash

# ---- CONFIG ----
WALL_DIR="$HOME/Pictures/Wallpapers"
INTERVAL=60
MODE="fill" # fill | fit | stretch | center | tile

# ---- PICK RANDOM WALLPAPER ----
pick_wallpaper() {
  find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1
}

CURRENT_PID=""

while true; do
  WALL_COUNT="$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | wc -l)"

  if [ "$WALL_COUNT" -le 1 ] && [ -n "$CURRENT_PID" ]; then
    # Only one wallpaper and already displaying it — just wait, no reload/unload
    sleep "$INTERVAL"
    continue
  fi

  # Zero wallpapers — nothing to show, just wait
  if [ "$WALL_COUNT" -eq 0 ]; then
    sleep "$INTERVAL"
    continue
  fi

  WALL="$(pick_wallpaper)"

  # Start new swaybg first
  swaybg -i "$WALL" -m "$MODE" &
  NEW_PID=$!

  # Allow swaybg to map before killing the old one
  sleep 0.3

  # Kill previous swaybg instance (prevents leaks)
  if [ -n "$CURRENT_PID" ]; then
    kill "$CURRENT_PID" 2>/dev/null
  fi

  CURRENT_PID="$NEW_PID"

  sleep "$INTERVAL"
done
