#!/bin/bash

# Tmux sessions mode - $ prefix

get_mode_info() {
    echo "$ 📟 Tmux --tmux"
}

load_data() {
    command -v tmux >/dev/null 2>&1 || return
    
    # Use the same approach as tmux-session-wizard-rewired
    (
        # First: Get existing tmux sessions sorted by recency
        if tmux list-sessions >/dev/null 2>&1; then
            tmux list-sessions -F "#{session_last_attached} #{session_name}: #{session_windows} window(s)#{?session_attached, (attached),}" 2>/dev/null | \
            sort -rn | cut -d' ' -f2- | while read -r session_info; do
                local session_name=$(echo "$session_info" | cut -d':' -f1)
                local session_desc=$(echo "$session_info" | cut -d':' -f2-)
                echo "$ $session_name"$'\033[90m'" ·$session_desc"$'\033[0m'$'\t'"$ $session_name $session_desc"$'\t'"tmux_session:$session_name"
            done
        fi
        
        # Second: Add zoxide directories for new session creation
        if command -v zoxide >/dev/null 2>&1; then
            zoxide query -l | grep -v '^/$' | grep -v '^/tmp' | grep -v '^/var' | head -60 | while read -r dir; do
                local dir_tilde=$(echo "$dir" | sed "s|$HOME|~|g")
                local dir_name=$(basename "$dir_tilde")
                echo "$ $dir_name"$'\033[90m'" · Create session in $dir_tilde"$'\033[0m'$'\t'"$ $dir_name $dir_tilde new session"$'\t'"tmux_new:$dir"
            done
        fi
    )
}

handle_selection() {
    local selected="$1"
    local has_hyprctl=false
    command -v hyprctl >/dev/null 2>&1 && has_hyprctl=true
    
    # Check if it's a tmux session command
    if [[ "$selected" =~ ^tmux_session: ]]; then
        # Extract session name and attach to it
        local session_name="${selected#tmux_session:}"
        
        # Check if we're in terminal mode (launched with -t)
        if [[ -n "$OMARCHY_PREVIOUS_WINDOW_FILE" ]]; then
            # We're in terminal mode - use current terminal and attach to session
            launch_in_current_terminal "tmux attach -t '$session_name'"
        else
            # Not in terminal mode - launch new alacritty window
            if $has_hyprctl; then
                hyprctl dispatch exec "alacritty -e tmux attach -t '$session_name'"
            else
                alacritty -e tmux attach -t "$session_name" >/dev/null 2>&1 &
            fi
        fi
        return 0
    # Check if it's a tmux new session command  
    elif [[ "$selected" =~ ^tmux_new: ]]; then
        # Extract directory path and create new session
        local dir_path="${selected#tmux_new:}"
        local session_name=$(basename "$dir_path" | tr '.[:upper:]' '_[:lower:]')
        
        # Check if we're in terminal mode (launched with -t)
        if [[ -n "$OMARCHY_PREVIOUS_WINDOW_FILE" ]]; then
            # We're in terminal mode - use current terminal
            if ! tmux has-session -t="$session_name" 2>/dev/null; then
                launch_in_current_terminal "tmux new-session -s '$session_name' -c '$dir_path'"
            else
                launch_in_current_terminal "tmux attach -t '$session_name'"
            fi
        else
            # Not in terminal mode - launch new alacritty window
            if $has_hyprctl; then
                if ! tmux has-session -t="$session_name" 2>/dev/null; then
                    hyprctl dispatch exec "alacritty -e tmux new-session -s '$session_name' -c '$dir_path'"
                else
                    hyprctl dispatch exec "alacritty -e tmux attach -t '$session_name'"
                fi
            else
                if ! tmux has-session -t="$session_name" 2>/dev/null; then
                    alacritty -e tmux new-session -s "$session_name" -c "$dir_path" >/dev/null 2>&1 &
                else
                    alacritty -e tmux attach -t "$session_name" >/dev/null 2>&1 &
                fi
            fi
        fi
        return 0
    fi
    
    return 1
}