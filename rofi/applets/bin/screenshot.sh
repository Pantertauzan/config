#!/usr/bin/env bash

source "$HOME/.config/rofi/applets/shared/theme.bash"
theme="$type/$style"

# Theme elements
prompt='Screenshot'
dir="$(xdg-user-dir PICTURES)/Screenshots"
mesg="DIR: $dir"

if [[ "$theme" == *'type-1'* ]]; then
    list_col='1'; list_row='5'; win_width='400px'
elif [[ "$theme" == *'type-3'* ]]; then
    list_col='1'; list_row='5'; win_width='120px'
elif [[ "$theme" == *'type-5'* ]]; then
    list_col='1'; list_row='5'; win_width='520px'
elif [[ "$theme" == *'type-2'* || "$theme" == *'type-4'* ]]; then
    list_col='5'; list_row='1'; win_width='670px'
fi

# Options
layout=$(grep 'USE_ICON' "$theme" | cut -d'=' -f2 | tr -d '[:space:]')

if [[ "$layout" == 'NO' ]]; then
    option_1=" Capture Area"
    option_2=" Capture Desktop"
    option_3=" Capture Window"
    option_4=" Capture in 5s"
    option_5=" Capture in 10s"
else
    option_1=""
    option_2=""
    option_3=""
    option_4=""
    option_5=""
fi

mkdir -p "$dir"

# Rofi menu
rofi_cmd() {
    rofi -theme-str "window {width: $win_width;}" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'inputbar { enabled: false; }' \
        -theme-str 'message { enabled: false; }' \
        -dmenu \
        -theme "$theme"
}

run_rofi() {
    printf '%s\n' \
        "$option_1" "$option_2" "$option_3" \
        "$option_4" "$option_5" | rofi_cmd
}

# Capture and annotate using Satty
capture() {
    local mode="$1"
    local timestamp geometry=""
    local output

    timestamp=$(date +%Y-%m-%d-%H-%M-%S)
    output="$dir/Screenshot_${timestamp}.png"

    case "$mode" in
        area|window)
            geometry=$(slurp) || return 0
            [[ -n "$geometry" ]] || return 0
            grim -g "$geometry" "$output" || return 1
            ;;
        desktop)
            grim "$output" || return 1
            ;;
    esac

    # Copy the saved screenshot directly to the Wayland clipboard
    wl-copy --type image/png < "$output"

    notify-send "Screenshot saved" \
        "Saved and copied to clipboard: $output"
}

# Countdown
countdown() {
    local sec
    for ((sec=$1; sec>=1; sec--)); do
        notify-send -t 1000 "Screenshot" "Taking shot in: $sec"
        sleep 1
    done
}

shotnow() { capture desktop; }
shotarea() { capture area; }
shotwin() { capture window; }

shot5() {
    countdown 5
    capture desktop
}

shot10() {
    countdown 10
    capture desktop
}

# Execute selected action
chosen="$(run_rofi)"

case "$chosen" in
    "$option_1") shotarea ;;
    "$option_2") shotnow ;;
    "$option_3") shotwin ;;
    "$option_4") shot5 ;;
    "$option_5") shot10 ;;
esac
