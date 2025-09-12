#!/bin/bash

# Theme selection mode - :theme prefix

get_mode_info() {
    echo ":theme 🎨 Theme --themes"
}

load_data() {
    local themes_dir="$HOME/.config/system-setup/themes/"
    local current_theme_dir="$HOME/.config/system-setup/current/theme"
    
    # Check if themes directory exists
    [[ -d "$themes_dir" ]] || return
    
    # Get current theme name
    local current_theme_name=""
    if [[ -e "$current_theme_dir" ]]; then
        current_theme_name=$(basename "$(realpath "$current_theme_dir" 2>/dev/null)" 2>/dev/null)
    fi
    
    # List available themes (both directories and symlinks)
    find "$themes_dir" -mindepth 1 -maxdepth 1 \( -type d -o -type l \) -printf "%f\n" 2>/dev/null | sort | while read -r theme; do
        [[ -z "$theme" ]] && continue
        
        local display_name="🎨 $theme"
        local command_string=""
        
        if [[ "$theme" == "$current_theme_name" ]]; then
            display_name="$display_name"$'\x1b[90m'" · current"$'\x1b[0m'
            # No-op command for current theme
            command_string="echo 'Theme $theme is already active'"
        else
            display_name="$display_name"$'\x1b[90m'" · switch theme"$'\x1b[0m'
            # Use the theme set script
            command_string="hyprctl dispatch exec \"$HOME/.local/share/system-setup/bin/system-setup-theme-set $theme\""
        fi
        
        echo ":theme $display_name"$'\t'":theme $theme switch theme"$'\t'"$command_string"
    done
}

handle_selection() {
    local selected="$1"
    
    # Check if it's a direct command (hyprctl, systemctl, etc.)
    if [[ "$selected" =~ ^(loginctl|systemctl|hyprctl|system-setup-|/home/[^/]+/.local/share/system-setup/bin/|echo) ]]; then
        # Execute system action directly
        eval "$selected"
        return 0
    fi
    
    return 1
}
