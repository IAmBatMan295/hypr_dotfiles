#!/bin/bash

# 1. Get History
HISTORY_SNAPSHOT=$(cliphist list)

# 2. Options
CLEAR_OPTION="  Clear History"
EMPTY_MESSAGE="   [Empty]"

if [ -z "$HISTORY_SNAPSHOT" ]; then
    MENU_ITEMS="$EMPTY_MESSAGE"
else
    # Map IDs
    mapfile -t CLIPHIST_IDS < <(echo "$HISTORY_SNAPSHOT" | awk '{print $1}')
    # Format List: Strip binary tags, remove IDs, number them
    MENU_ITEMS=$(echo "$HISTORY_SNAPSHOT" | \
                 sed 's/\[\[ binary data \(.*\) \]\]/[\1]/' | \
                 awk '{$1=""; print $0}' | \
                 sed 's/^\s*//' | \
                 nl -w 1 -s ". ")
fi

FINAL_MENU=$(printf "%s\n%s" "$MENU_ITEMS" "$CLEAR_OPTION")

# 3. Launch Rofi with the Card Theme
SELECTED_ITEM=$(echo "$FINAL_MENU" | rofi -dmenu \
    -theme ~/.config/rofi/clipboard_menu.rasi \
    -p " " \
    -i)

# 4. Logic
if [ -z "$SELECTED_ITEM" ]; then exit 0; fi

if [ "$SELECTED_ITEM" = "$CLEAR_OPTION" ]; then
    cliphist wipe
    wl-copy --clear
    exit 0
fi

if [ "$SELECTED_ITEM" = "$EMPTY_MESSAGE" ]; then exit 0; fi

# Extract ID and Copy
LINE_NUMBER=$(echo "$SELECTED_ITEM" | awk -F '.' '{print $1}')
ARRAY_INDEX=$((LINE_NUMBER - 1))
ID_TO_COPY=${CLIPHIST_IDS[ARRAY_INDEX]}

cliphist decode "$ID_TO_COPY" | wl-copy
