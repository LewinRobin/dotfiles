#!/bin/bash

# 1. Load API Key
source "$HOME/.bashrc"

# 2. Grab text selection
selection=$(xclip -o -selection primary 2>/dev/null || xclip -o -selection clipboard 2>/dev/null)

if [ -z "$selection" ]; then
    zenity --error --text="No text selected!"
    exit 1
fi

# 3. Show prompt with selection preview
preview="${selection:0:100}..."
user_question=$(zenity --entry --title="Gemini 3.1 Lite" --text="Selected Text:\n\"$preview\"\n\nWhat is your question?")

if [ $? -ne 0 ] || [ -z "$user_question" ]; then
    exit 0
fi

# 4. Create the JSON payload using jq
# 'max_output_tokens' ensures the model doesn't ramble or get cut off mid-sentence
JSON_PAYLOAD=$(jq -n \
  --arg prompt "Instructions: Provide a small, precise, and concise answer. Avoid jargon. Context: $selection. Question: $user_question" \
  '{
    contents: [{parts: [{text: $prompt}]}],
    generationConfig: {
      maxOutputTokens: 500,
      temperature: 0.2
    }
  }')

# 5. Call API (Using v1beta for Gemini 3.1 models)
MODEL="gemini-3.1-flash-lite"
notify-send "Gemini" "Getting precise answer..."

response=$(curl -s "https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent?key=${GEMINI_API_KEY}" \
    -H 'Content-Type: application/json' \
    -X POST \
    -d "$JSON_PAYLOAD")

# 6. Parse the answer
answer=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text' 2>/dev/null)

# 7. Display with a scrollable text box to prevent chopping
if [ "$answer" != "null" ] && [ -n "$answer" ]; then
    echo "$answer" | xclip -selection clipboard
    # Using --text-info instead of --info allows for scrolling and better text handling
    echo "$answer" | zenity --text-info --title="Gemini Answer" --width=600 --height=400 --font="sans 12"
else
    error_detail=$(echo "$response" | jq -r '.error.message // "Unknown error - check connection."')
    zenity --error --text="Details: $error_detail"
fi
