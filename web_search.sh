#!/usr/bin/env bash

# Define search engines
declare -A engines
engines=(
    # --- Essentials ---
    ["Google"]="https://www.google.com/search?q="
    ["YouTube"]="https://www.youtube.com/results?search_query="
    ["Brave Search"]="https://search.brave.com/search?q="
    ["DuckDuckGo"]="https://duckduckgo.com/?q="
    
    # --- Tech & Dev ---
    ["GitHub"]="https://github.com/search?q="
    ["Stack Overflow"]="https://stackoverflow.com/search?q="
    ["Reddit"]="https://www.reddit.com/search/?q="
    ["PyPi"]="https://pypi.org/search/?q="
    ["MDN Web Docs"]="https://developer.mozilla.org/en-US/search?q="
    ["Arch Wiki"]="https://wiki.archlinux.org/index.php?search="
    
    # --- Shopping & Maps ---
    ["Amazon"]="https://www.amazon.com/s?k="
    ["eBay"]="https://www.ebay.com/sch/i.html?_nkw="
    ["Google Maps"]="https://www.google.com/maps/search/"
    ["Wikipedia"]="https://en.wikipedia.org/wiki/Special:Search?search="

    # --- Entertainment & Social ---
    ["Twitch"]="https://www.twitch.tv/search?term="
    ["Twitter/X"]="https://twitter.com/search?q="
    ["Spotify"]="https://open.spotify.com/search/"
)

# 1. Select the search engine
# We use 'printf' to keep the names neat in the Rofi list
options=$(printf "%s\n" "${!engines[@]}" | sort)
selected=$(echo -e "$options" | rofi -dmenu -i -p "Search via:" -theme-str 'window {width: 30%;}')

if [[ -z "$selected" ]]; then
    exit 1
fi

# 2. Enter the search query
query=$(rofi -dmenu -p "Enter query for $selected:")

if [[ -z "$query" ]]; then
    exit 1
fi

# 3. URL Encode the query safely using Python (standard in Debian)
uri_query=$(python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read().strip()))" <<< "$query")

# 4. Open the result
xdg-open "${engines[$selected]}$uri_query"
