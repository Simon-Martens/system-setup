#!/bin/bash

# CPU Governor mode - :governor prefix

get_mode_info() {
    echo ":governor ⚙️ Governor --governor"
}

load_data() {
    # Get available CPU governors and create actions dynamically
    if [[ -f "/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors" ]]; then
        local current_governor=""
        if [[ -f "/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" ]]; then
            current_governor=$(cat "/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" 2>/dev/null)
        fi
        
        while read -r gov; do
            [[ -z "$gov" ]] && continue
            
            local display_name="$gov"
            local command_string=""
            
            if [[ "$gov" == "$current_governor" ]]; then
                display_name="$display_name"$'\033[90m'" · current"$'\033[0m'
                # No-op command for current governor
                command_string="echo 'Governor $gov is already active'"
            else  
                display_name="$display_name"$'\033[90m'" · set CPU governor"$'\033[0m'
                # Use the dedicated governor script
                command_string="hyprctl dispatch exec \"$HOME/.local/share/omarchy/bin/omarchy-set-governor $gov\""
            fi
            
            echo ":governor $display_name"$'\t'":governor $gov set CPU governor"$'\t'"$command_string"
        done < <(cat "/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors" | tr ' ' '\n' | sort)
    fi
}

handle_selection() {
    local selected="$1"
    
    # Check if it's a direct command (hyprctl, systemctl, etc.)
    if [[ "$selected" =~ ^(loginctl|systemctl|hyprctl|omarchy-|/home/[^/]+/.local/share/omarchy/bin/|echo) ]]; then
        # Execute system action directly
        eval "$selected"
        return 0
    fi
    
    return 1
}