#!/bin/bash

# Workspaces mode - // prefix

get_mode_info() {
    echo "// 🏢 Workspaces --workspaces"
}

load_data() {
    command -v hyprctl >/dev/null 2>&1 || return
    
    # Get active workspaces with their last window titles
    hyprctl -j workspaces 2>/dev/null | jq -r '
        .[] | 
        select(.windows > 0) |
        "// " + (.id | tostring) + ": " + .lastwindowtitle +
        "\u001b[90m · " + (.windows | tostring) + " windows\u001b[0m" +
        "\t// " + (.id | tostring) + " " + .lastwindowtitle +
        "\tworkspace:" + (.id | tostring)
    ' 2>/dev/null
}

handle_selection() {
    local selected="$1"
    
    # Check if it's a workspace switch command
    if [[ "$selected" =~ ^workspace: ]]; then
        # Extract workspace number and switch to it
        local workspace_id="${selected#workspace:}"
        command -v hyprctl >/dev/null 2>&1 && hyprctl dispatch workspace "$workspace_id"
        return 0
    fi
    
    return 1
}