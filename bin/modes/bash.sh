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
    
    # Show both options: run and return to launcher, or run and start shell
    echo "💻 Run '$cmd'"$'\t'"💻 Run '$cmd'"$'\t'"run_cmd_in_terminal:$cmd"
    echo "🖥️ Run '$cmd' + shell"$'\t'"🖥️ Run '$cmd' and start interactive shell"$'\t'"run_cmd_with_shell:$cmd"
}

handle_selection() {
    local selected="$1"
    
    # Check if it's a bash command run request (original behavior)
    if [[ "$selected" =~ ^run_cmd_in_terminal: ]]; then
        # Extract command
        local cmd="${selected#run_cmd_in_terminal:}"
        
        # Check if we're in terminal mode (launched with -t)
        if [[ -n "$OMARCHY_PREVIOUS_WINDOW_FILE" ]]; then
            # We're in terminal mode - run command directly in current terminal
            clear
            echo "════════════════════════════════════════"
            echo "💻 Executing: $cmd"
            echo "════════════════════════════════════════"
            echo
            
            # Execute the command
            eval "$cmd"
            
            echo
            echo "════════════════════════════════════════"
            echo "Press Enter to return to launcher..."
            read -r
            
            # Return successfully so the main launcher loop continues
            return 0
        else
            # Not in terminal mode - launch new alacritty window
            launch_app "alacritty -e bash -c '$cmd; exec bash'"
        fi
        return 0
    fi
    
    # Check if it's a bash command with shell request (new behavior)
    if [[ "$selected" =~ ^run_cmd_with_shell: ]]; then
        # Extract command
        local cmd="${selected#run_cmd_with_shell:}"
        
        # Check if we're in terminal mode (launched with -t)
        if [[ -n "$OMARCHY_PREVIOUS_WINDOW_FILE" ]]; then
            # We're in terminal mode - convert current window and run command + shell
            launch_in_current_terminal "$cmd; exec bash"
        else
            # Not in terminal mode - launch new alacritty window
            launch_app "alacritty -e bash -c '$cmd; exec bash'"
        fi
        return 0
    fi
    
    return 1
}