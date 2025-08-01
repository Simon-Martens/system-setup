#!/bin/bash

# Workspace management mode - :workspaces prefix

get_mode_info() {
    echo ":ws 🖥️ Workspaces --ws"
}

# Workspace switching functions
workspace_1() {
    hyprctl dispatch workspace 1
}

workspace_2() {
    hyprctl dispatch workspace 2
}

workspace_3() {
    hyprctl dispatch workspace 3
}

workspace_4() {
    hyprctl dispatch workspace 4
}

workspace_5() {
    hyprctl dispatch workspace 5
}

workspace_6() {
    hyprctl dispatch workspace 6
}

next_workspace() {
    hyprctl dispatch workspace +1
}

prev_workspace() {
    hyprctl dispatch workspace -1
}

# Window movement to workspace functions
move_to_workspace_1() {
    hyprctl dispatch movetoworkspace 1
}

move_to_workspace_2() {
    hyprctl dispatch movetoworkspace 2
}

move_to_workspace_3() {
    hyprctl dispatch movetoworkspace 3
}

move_to_workspace_4() {
    hyprctl dispatch movetoworkspace 4
}

move_to_workspace_5() {
    hyprctl dispatch movetoworkspace 5
}

move_to_workspace_6() {
    hyprctl dispatch movetoworkspace 6
}

load_data() {
    # Workspace switching actions
    echo ":ws Workspace 1"$'\x1b[90m'" · Switch to workspace 1"$'\x1b[0m'$'\t'":ws Workspace 1 Switch to workspace 1"$'\t'"workspace_1"
    echo ":ws Workspace 2"$'\x1b[90m'" · Switch to workspace 2"$'\x1b[0m'$'\t'":ws Workspace 2 Switch to workspace 2"$'\t'"workspace_2"
    echo ":ws Workspace 3"$'\x1b[90m'" · Switch to workspace 3"$'\x1b[0m'$'\t'":ws Workspace 3 Switch to workspace 3"$'\t'"workspace_3"
    echo ":ws Workspace 4"$'\x1b[90m'" · Switch to workspace 4"$'\x1b[0m'$'\t'":ws Workspace 4 Switch to workspace 4"$'\t'"workspace_4"
    echo ":ws Workspace 5"$'\x1b[90m'" · Switch to workspace 5"$'\x1b[0m'$'\t'":ws Workspace 5 Switch to workspace 5"$'\t'"workspace_5"
    echo ":ws Workspace 6"$'\x1b[90m'" · Switch to workspace 6"$'\x1b[0m'$'\t'":ws Workspace 6 Switch to workspace 6"$'\t'"workspace_6"
    echo ":ws Next Workspace"$'\x1b[90m'" · Switch to next workspace"$'\x1b[0m'$'\t'":ws Next Workspace Switch to next workspace"$'\t'"next_workspace"
    echo ":ws Prev Workspace"$'\x1b[90m'" · Switch to previous workspace"$'\x1b[0m'$'\t'":ws Prev Workspace Switch to previous workspace"$'\t'"prev_workspace"
    
    # Window movement actions
    echo ":ws Move to WS 1"$'\x1b[90m'" · Move window to workspace 1"$'\x1b[0m'$'\t'":ws Move to WS 1 Move window to workspace 1"$'\t'"move_to_workspace_1"
    echo ":ws Move to WS 2"$'\x1b[90m'" · Move window to workspace 2"$'\x1b[0m'$'\t'":ws Move to WS 2 Move window to workspace 2"$'\t'"move_to_workspace_2"
    echo ":ws Move to WS 3"$'\x1b[90m'" · Move window to workspace 3"$'\x1b[0m'$'\t'":ws Move to WS 3 Move window to workspace 3"$'\t'"move_to_workspace_3"
    echo ":ws Move to WS 4"$'\x1b[90m'" · Move window to workspace 4"$'\x1b[0m'$'\t'":ws Move to WS 4 Move window to workspace 4"$'\t'"move_to_workspace_4"
    echo ":ws Move to WS 5"$'\x1b[90m'" · Move window to workspace 5"$'\x1b[0m'$'\t'":ws Move to WS 5 Move window to workspace 5"$'\t'"move_to_workspace_5"
    echo ":ws Move to WS 6"$'\x1b[90m'" · Move window to workspace 6"$'\x1b[0m'$'\t'":ws Move to WS 6 Move window to workspace 6"$'\t'"move_to_workspace_6"
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