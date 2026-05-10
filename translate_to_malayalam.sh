#!/bin/bash

# 2. Grab text from the Primary Selection or Clipboard
selection=$(xclip -o -selection primary 2>/dev/null || xclip -o -selection clipboard 2>/dev/null)

# 3. If selection is empty, exit
if [ -z "$selection" ]; then
    exit
fi

# --- FIX START ---
# Replace newlines with spaces and squeeze multiple spaces into one
selection=$(echo "$selection" | tr '\n' ' ' | xargs)
# --- FIX END ---

# 4. Use absolute paths (Verify these with 'which trans' and 'which notify-send')
TRANS_BIN="/usr/local/bin/trans"
NOTIFY_BIN="/usr/bin/notify-send"

# 5. Translate to Malayalam
translation=$($TRANS_BIN -b -to ml "$selection")

# 6. Show notification
$NOTIFY_BIN "Malayalam Translation" "$translation"
