#!/bin/bash

# Power actions mode - :power prefix

get_mode_info() {
    echo ":power 🔌 Power --power"
}

# Power management functions
lock_session() {
    hyprctl dispatch exec hyprlock
}

suspend_system() {
    systemctl suspend
}

relaunch_hyprland() {
    hyprctl dispatch exit
}

relaunch_waybar() {
    pkill waybar && hyprctl dispatch exec waybar &
}

restart_system() {
    systemctl reboot
}

shutdown_system() {
    systemctl poweroff
}

load_data() {
    # Output power-related actions directly
    echo ":power Lock"$'\x1b[90m'" · Lock the current session"$'\x1b[0m'$'\t'":power Lock Lock the current session"$'\t'"lock_session"
    echo ":power Suspend"$'\x1b[90m'" · Suspend the system"$'\x1b[0m'$'\t'":power Suspend Suspend the system"$'\t'"suspend_system"
    echo ":power Relaunch"$'\x1b[90m'" · Restart Hyprland window manager"$'\x1b[0m'$'\t'":power Relaunch Restart Hyprland window manager"$'\t'"relaunch_hyprland"
    echo ":power Relaunch Waybar"$'\x1b[90m'" · Restart Waybar"$'\x1b[0m'$'\t'":power Relaunch Waybar Restart Waybar"$'\t'"relaunch_waybar"
    echo ":power Restart"$'\x1b[90m'" · Restart the system"$'\x1b[0m'$'\t'":power Restart Restart the system"$'\t'"restart_system"
    echo ":power Shutdown"$'\x1b[90m'" · Shut down the system"$'\x1b[0m'$'\t'":power Shutdown Shut down the system"$'\t'"shutdown_system"
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