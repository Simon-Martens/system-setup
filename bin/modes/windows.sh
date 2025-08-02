#!/bin/bash

# Windows mode - / prefix

get_mode_info() {
    echo "/ 🪟 Windows --windows"
}

load_data() {
    command -v hyprctl >/dev/null 2>&1 || return
    
    # Get all windows with their details
    hyprctl -j clients 2>/dev/null | jq -r '
        .[] | 
        select(.mapped == true) |
        select(.class != "launcher") |
        {
            title: (if .title == "" then .initialTitle else .title end),
            class: .class,
            address: .address,
            workspace: .workspace.name,
            minimized: (.workspace.name == "special:minimized")
        } |
        "/ " + .title + 
        (if .minimized then " (minimized)" else "" end) +
        "\u001b[90m · " + .class + "\u001b[0m" +
        "\t/ " + .title + " " + .class + 
        (if .minimized then " minimized" else "" end) +
        "\tfocus_window:" + .address
    ' 2>/dev/null
}

handle_selection() {
    local selected="$1"
    
    # Check if it's a window focus command
    if [[ "$selected" =~ ^focus_window: ]]; then
        # Extract window address and focus it
        local window_address="${selected#focus_window:}"
        if command -v hyprctl >/dev/null 2>&1; then
            # Check if window is minimized (in special:minimized workspace)
            local window_workspace=$(hyprctl -j clients | jq -r ".[] | select(.address == \"$window_address\") | .workspace.name")
            if [[ "$window_workspace" == "special:minimized" ]]; then
                # Window is minimized - restore it to current workspace
                local current_workspace=$(hyprctl -j activeworkspace | jq -r '.name')
                hyprctl dispatch movetoworkspace "$current_workspace,address:$window_address"
            fi
            hyprctl dispatch focuswindow "address:$window_address"
        fi
        return 0
    fi
    
    return 1
}
