#!/bin/bash

# Power actions mode - :power prefix

get_mode_info() {
    echo ":power 🔌 Power --power"
}

load_data() {
    local actions_script="$HOME/.local/share/omarchy/bin/actions.sh"
    [[ ! -f "$actions_script" ]] && return
    
    # Get only power-related actions and add :power prefix
    "$actions_script" | grep -E "(Lock|Suspend|Relaunch|Restart|Shutdown)" | while IFS=$'\t' read -r display_name search_text command; do
        echo ":power $display_name"$'\t'":power $search_text"$'\t'"$command"
    done
}

handle_selection() {
    local selected="$1"
    local actions_script="$HOME/.local/share/omarchy/bin/actions.sh"
    
    # Check if it's a direct command (hyprctl, systemctl, etc.)
    if [[ "$selected" =~ ^(loginctl|systemctl|hyprctl|omarchy-|/home/[^/]+/.local/share/omarchy/bin/) ]]; then
        # Execute system action directly
        eval "$selected"
        return 0
    # Check if it's a system action (function name from actions.sh)
    elif [[ -f "$actions_script" ]]; then
        # Source actions.sh first, then check if function exists
        source "$actions_script"
        if declare -f "$selected" >/dev/null 2>&1; then
            "$selected"
            return 0
        fi
    fi
    
    return 1
}