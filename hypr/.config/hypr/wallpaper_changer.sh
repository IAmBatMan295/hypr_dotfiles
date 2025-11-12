#!/bin/bash

WALLPAPER_DIR="/home/kunjan/Pictures/Wallpapers"
MONITOR="eDP-1"
INTERVAL=60

CURRENT_WALLPAPER=""

if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Error: Wallpaper directory '$WALLPAPER_DIR' not found." >&2
  exit 1
fi

while true; do
  mapfile -d $'\0' files < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" \) -print0)

  if [ ${#files[@]} -eq 0 ]; then
    echo "No wallpapers found in '$WALLPAPER_DIR'. Sleeping..." >&2
  else
    RANDOM_INDEX=$(( RANDOM % ${#files[@]} ))
    NEW_WALLPAPER="${files[$RANDOM_INDEX]}"

    hyprctl hyprpaper preload "$NEW_WALLPAPER"
    hyprctl hyprpaper wallpaper "$MONITOR,$NEW_WALLPAPER"

    if [[ -n "$CURRENT_WALLPAPER" && "$CURRENT_WALLPAPER" != "$NEW_WALLPAPER" ]]; then
      hyprctl hyprpaper unload "$CURRENT_WALLPAPER"
    fi

    CURRENT_WALLPAPER="$NEW_WALLPAPER"

    echo "Changed wallpaper to: $NEW_WALLPAPER"
  fi

  sleep "$INTERVAL"
done
