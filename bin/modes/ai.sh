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
    
    # Check if it's an AI question request
    if [[ "$selected" =~ ^ask_ai: ]]; then
        # Extract question
        local question="${selected#ask_ai:}"
        
        # Check if we're in terminal mode (launched with -t)
        if [[ -n "$TLAUNCHER_PREVIOUS_WINDOW_FILE" ]]; then
            # We're in terminal mode - run Claude directly in current terminal
            clear
            echo "════════════════════════════════════════"
            echo "🤖 Claude AI Assistant"
            echo "════════════════════════════════════════"
            echo
            echo "🤖 Question: $question"
            echo
            echo "Response:"
            echo "----------------------------------------"
            
            # Execute Claude
            /usr/bin/claude -p "$question"
            
            echo
            echo "----------------------------------------"
            echo "Press Enter to return to launcher..."
            read -r
            
            # Return successfully so the main launcher loop continues
            return 0
        else
            # Not in terminal mode - launch new alacritty window
            launch_app "alacritty --title 'Claude AI' -e bash -c 'echo \"🤖 Question: $question\"; echo; /usr/bin/claude -p \"$question\"; echo; echo \"Press any key to exit...\"; read -n1'"
        fi
        return 0
    fi
    
    return 1
}
