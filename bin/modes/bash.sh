#!/bin/bash

# Bash command execution mode - ! prefix

get_mode_info() {
    echo "! 💻 Bash --bash"
}

load_data() {
    local query="$1"
    # Extract command after "!" prefix
    local cmd="${query#!}"
    
    # Skip if no command or just "!"
    [[ -z "$cmd" || "$cmd" == " " ]] && return
    
    # Remove leading space if present  
    cmd="${cmd# }"
    
    # Skip if still empty
    [[ -z "$cmd" ]] && return
    
    # Just show option to run the command in terminal
    echo "💻 Run '$cmd'"$'\t'"💻 Run '$cmd'"$'\t'"run_cmd_in_terminal:$cmd"
}

handle_selection() {
    local selected="$1"
    local has_hyprctl=false
    command -v hyprctl >/dev/null 2>&1 && has_hyprctl=true
    
    # Check if it's a bash command run request
    if [[ "$selected" =~ ^run_cmd_in_terminal: ]]; then
        # Extract command and run in interactive terminal
        local cmd="${selected#run_cmd_in_terminal:}"
        if $has_hyprctl; then
            hyprctl dispatch exec "alacritty -e bash -c '$cmd; exec bash'"
        else
            alacritty -e bash -c "$cmd; exec bash" >/dev/null 2>&1 &
        fi
        return 0
    fi
    
    return 1
}