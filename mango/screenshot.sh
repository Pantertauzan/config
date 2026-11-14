#!/usr/bin/env bash

pipe=$(mktemp -u).fifo
mkfifo "$pipe"

wayfreeze --after-freeze-timeout 100 --after-freeze-cmd "echo > $pipe" &
wayfreeze_pid=$!

read -r < "$pipe"
geometry=$(slurp -d)

if [[ -z "$geometry" ]]; then
  kill "$wayfreeze_pid" 2>/dev/null
  rm -f "$pipe"
  exit 1
fi

screenshot="$HOME/Pictures/Screenshots/$(date +%d-%m-%Y).png"

if grim -g "$geometry" "$screenshot" &&
   wl-copy < "$screenshot"; then
  notify-send -a "Screenshot" "Screenshot saved" \
    "Image saved and copied to clipboard."
else
  notify-send -u critical -a "Screenshot" "Screenshot failed" \
    "Could not save or copy the image."
fi

kill "$wayfreeze_pid" 2>/dev/null
rm -f "$pipe"
