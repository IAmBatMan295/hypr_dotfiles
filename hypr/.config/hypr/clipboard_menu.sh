#!/bin/bash
# Remove the 'set-x' line for normal operation

# Call 'cliphist list' ONE TIME and store a snapshot.
HISTORY_SNAPSHOT=$(cliphist list)

# --- Define special menu options ---
CLEAR_OPTION="  Clear History"
EMPTY_MESSAGE="   [Empty]"

# --- Check if history is empty ---
if [ -z "$HISTORY_SNAPSHOT" ]; then
    # History is empty. Menu will be "[Empty]" and "Clear".
    MENU_ITEMS="$EMPTY_MESSAGE"
else
    # History is not empty. Build list and map IDs.
    mapfile -t CLIPHIST_IDS < <(echo "$HISTORY_SNAPSHOT" | awk '{print $1}')
    MENU_ITEMS=$(echo "$HISTORY_SNAPSHOT" | \
                 # Use the better parser for image info
                 sed 's/\[\[ binary data \(.*\) \]\]/[\1]/' | \
                 awk '{$1=""; print $0}' | \
                 sed 's/^\s*//' | \
                 nl -w 1 -s ". ")
fi

# Add the clear option to the menu list
FINAL_MENU=$(printf "%s\n%s" "$MENU_ITEMS" "$CLEAR_OPTION")

# Let the user select from the clean, numbered list
SELECTED_ITEM=$(echo "$FINAL_MENU" | fuzzel \
                    --dmenu \
                    --prompt $'\uf0ea  ' \
                    --lines=6 \
                    --width=60)

# Handle if the user presses ESC
[ -z "$SELECTED_ITEM" ] && exit

# --- Check if the user selected the clear option ---
if [ "$SELECTED_ITEM" = "$CLEAR_OPTION" ]; then
    cliphist wipe      # Clears the history database
    wl-copy --clear    # Clears the active system clipboard
    exit 0
fi

# --- Check if the user selected "Empty" ---
if [ "$SELECTED_ITEM" = "$EMPTY_MESSAGE" ]; then
    exit 0 # It's just a message, do nothing.
fi

# --- EXISTING LOGIC ---

# Get the line *number* from the user's selection
LINE_NUMBER=$(echo "$SELECTED_ITEM" | awk -F '.' '{print $1}')

# An array index starts at 0, but 'nl' starts numbering at 1.
# So, we subtract 1 to get the correct index.
ARRAY_INDEX=$((LINE_NUMBER - 1))

# Get the *real* cliphist ID from our stable array
ID_TO_COPY=${CLIPHIST_IDS[ARRAY_INDEX]}

# --- THE FIX ---
# We do not use the '--id' flag.
# We pass the ID variable directly to 'cliphist decode'.
cliphist decode "$ID_TO_COPY" | wl-copy
