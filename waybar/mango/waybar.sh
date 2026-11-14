#!/usr/bin/env bash

pkill waybar
waybar -c "$HOME/.config/waybar/mango/config.jsonc" \
       -s "$HOME/.config/waybar/mango/style.css" &
