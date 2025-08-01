#!/bin/bash

# Location switching mode - :location prefix

get_mode_info() {
    echo ":location 🌍 Location --location"
}

# Detect current location from hyprland config
get_current_location() {
    local hypr_config="$HOME/.config/hypr/hyprland.conf"
    
    if [[ ! -f "$hypr_config" ]]; then
        echo "unknown"
        return
    fi
    
    if grep -q "source = ~/.config/hypr/work.conf" "$hypr_config"; then
        echo "work"
    elif grep -q "source = ~/.config/hypr/home.conf" "$hypr_config"; then
        echo "home"
    elif grep -q "source = ~/.config/hypr/laptop.conf" "$hypr_config"; then
        echo "laptop"
    else
        echo "unknown"
    fi
}

# Check if a location config file exists
location_config_exists() {
    local location="$1"
    [[ -f "$HOME/.config/hypr/$location.conf" ]]
}

load_data() {
    local current_location
    current_location=$(get_current_location)
    
    # Available locations
    local locations=("work" "home" "laptop")
    
    for location in "${locations[@]}"; do
        # Check if config file exists for this location
        if ! location_config_exists "$location"; then
            continue
        fi
        
        local display_name="🌍 $location"
        local command_string=""
        
        if [[ "$location" == "$current_location" ]]; then
            display_name="$display_name"$'\x1b[90m'" · current"$'\x1b[0m'
            # No-op command for current location
            command_string="echo 'Already at location: $location'"
        else
            display_name="$display_name"$'\x1b[90m'" · switch location"$'\x1b[0m'
            # Use the set-location script
            command_string="$HOME/.local/share/omarchy/bin/set-location $location"
        fi
        
        echo ":location $display_name"$'\t'":location $location switch location"$'\t'"$command_string"
    done
}

# Function to show current location
show_current_location() {
    local current_location
    current_location=$(get_current_location)
    
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Current Location" "Location: $current_location" -i preferences-system
    else
        echo "Current location: $current_location"
    fi
}

handle_selection() {
    local selected="$1"
    
    # Check if it's the show current location command
    if [[ "$selected" == "show_current_location" ]]; then
        show_current_location
        return 0
    fi
    
    # Check if it's a direct command (our set-location script or echo)
    if [[ "$selected" =~ ^(echo|/home/[^/]+/.local/share/omarchy/bin/set-location) ]]; then
        # Execute the command
        eval "$selected"
        return 0
    fi
    
    return 1
}