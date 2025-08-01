#!/bin/bash

# Window management mode - :window prefix

get_mode_info() {
    echo ":win 🪟 Window --win"
}

# Get the previously active window (before the launcher)
get_previous_window() {
    # Get all windows sorted by focus history, excluding launcher-related windows
    local windows=$(hyprctl -j clients | jq -r '
        .[] | 
        select(.focusHistoryID >= 0 and .class != "omarchy-launcher" and .class != "fzf" and .title != "omarchy-launcher") | 
        "\(.focusHistoryID) \(.address)"
    ' | sort -nr)
    
    # Get the most recently focused non-launcher window
    local target_window=$(echo "$windows" | head -n 1 | awk '{print $2}')
    
    echo "$target_window"
}

# Window management functions that work on the previous window
minimize_window() {
    # Use the existing minimizer script which already handles window detection
    hyprctl dispatch exec ~/.local/share/omarchy/bin/hyprland-minimizer
}

close_window() {
    # Use the existing close window script which already handles window detection
    hyprctl dispatch exec ~/.local/share/omarchy/bin/omarchy-close-window
}

toggle_float() {
    local prev_window=$(get_previous_window)
    if [[ -n "$prev_window" ]]; then
        hyprctl dispatch togglefloating "address:$prev_window"
    else
        # Fallback: use killactive approach - close launcher and apply to previous
        sleep 0.1 && hyprctl dispatch togglefloating &
        exit 0
    fi
}

toggle_fullscreen() {
    local prev_window=$(get_previous_window)
    if [[ -n "$prev_window" ]]; then
        hyprctl dispatch fullscreen "address:$prev_window"
    else
        # Fallback: use killactive approach
        sleep 0.1 && hyprctl dispatch fullscreen &
        exit 0
    fi
}

pseudo_tile() {
    local prev_window=$(get_previous_window)
    if [[ -n "$prev_window" ]]; then
        hyprctl dispatch pseudo "address:$prev_window"
    else
        sleep 0.1 && hyprctl dispatch pseudo &
        exit 0
    fi
}

pin_window() {
    local prev_window=$(get_previous_window)
    if [[ -n "$prev_window" ]]; then
        hyprctl dispatch pin "address:$prev_window"
    else
        sleep 0.1 && hyprctl dispatch pin &
        exit 0
    fi
}

center_window() {
    local prev_window=$(get_previous_window)
    if [[ -n "$prev_window" ]]; then
        hyprctl dispatch centerwindow "address:$prev_window"
    else
        sleep 0.1 && hyprctl dispatch centerwindow &
        exit 0
    fi
}

# Window restoration function
restore_windows() {
    hyprctl dispatch exec ~/.local/share/omarchy/bin/omarchy-show-minimized-fzf-terminal
}

load_data() {
    # Window management actions
    echo ":win Minimize"$'\x1b[90m'" · Minimize current window"$'\x1b[0m'$'\t'":win Minimize Minimize current window"$'\t'"minimize_window"
    echo ":win Restore"$'\x1b[90m'" · Show minimized windows"$'\x1b[0m'$'\t'":win Restore Show minimized windows"$'\t'"restore_windows"
    echo ":win Close"$'\x1b[90m'" · Close current window"$'\x1b[0m'$'\t'":win Close Close current window"$'\t'"close_window"
    echo ":win Float"$'\x1b[90m'" · Toggle floating window"$'\x1b[0m'$'\t'":win Float Toggle floating window"$'\t'"toggle_float"
    echo ":win Fullscreen"$'\x1b[90m'" · Toggle fullscreen"$'\x1b[0m'$'\t'":win Fullscreen Toggle fullscreen"$'\t'"toggle_fullscreen"
    echo ":win Pseudo Tile"$'\x1b[90m'" · Toggle pseudo tiling"$'\x1b[0m'$'\t'":win Pseudo Tile Toggle pseudo tiling"$'\t'"pseudo_tile"
    echo ":win Pin Window"$'\x1b[90m'" · Pin window to all workspaces"$'\x1b[0m'$'\t'":win Pin Window Pin window to all workspaces"$'\t'"pin_window"
    echo ":win Center Window"$'\x1b[90m'" · Center floating window"$'\x1b[0m'$'\t'":win Center Window Center floating window"$'\t'"center_window"
}

handle_selection() {
    local selected="$1"
    
    # Check if it's a direct command (hyprctl, systemctl, etc.)
    if [[ "$selected" =~ ^(loginctl|systemctl|hyprctl|omarchy-|/home/[^/]+/.local/share/omarchy/bin/) ]]; then
        # Execute system action directly
        eval "$selected"
        return 0
    # Check if it's a function defined in this script
    elif declare -f "$selected" >/dev/null 2>&1; then
        "$selected"
        return 0
    fi
    
    return 1
}