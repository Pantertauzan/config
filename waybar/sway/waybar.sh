#!/usr/bin/env bash

pkill waybar
waybar -c "$HOME/.config/waybar/sway/config.jsonc" \
       -s "$HOME/.config/waybar/sway/style.css" &
