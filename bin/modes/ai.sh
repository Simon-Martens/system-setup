#!/bin/bash

# Bash command execution mode - ! prefix

get_mode_info() {
    echo "? 🤖AI --ai"
}

load_data() {
    local query="$1"
    # Extract command after "@" prefix
    #local cmd="${query#\@}"
		local cmd="${query}"
    
    # Skip if no command or just "@"
    [[ -z "$cmd" || "$cmd" == " " ]] && return
    
    # Remove leading space if present  
    cmd="${cmd# }"
    
    # Skip if still empty
    [[ -z "$cmd" ]] && return
    
    # Just show option to run the command in terminal
    echo "󰋖 Query '$cmd'"$'\t'"󰋖 Query Claude"$'\t'"ask_ai:$cmd"
}

handle_selection() {
    local selected="$1"
    local has_hyprctl=false
    command -v hyprctl >/dev/null 2>&1 && has_hyprctl=true
    
    # Check if it's a bash command run request
    if [[ "$selected" =~ ^ask_ai: ]]; then
        # Extract command and run in interactive terminal
        local cmd="${selected#ask_ai:}"
        if $has_hyprctl; then
            hyprctl dispatch exec "alacritty --title 'Claude AI' -e bash -c 'echo \"🤖 Question: $cmd\"; echo; /usr/bin/claude -p \"$cmd\"; echo; echo \"Press any key to exit...\"; read -n1'"
        else
            alacritty --title 'Claude AI' -e bash -c "echo '🤖 Question: $cmd'; echo; /usr/bin/claude -p '$cmd'; echo; echo 'Press any key to exit...'; read -n1" >/dev/null 2>&1 &
        fi
        return 0
    fi
    
    return 1
}
