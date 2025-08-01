#!/bin/bash

# AI assistant mode - # prefix

get_mode_info() {
    echo "# 🤖 AI --ai"
}

load_data() {
    local query="$1"
    # Extract question after "#" prefix
    local question="${query##\#}"
    
    # Skip if no question or just "#"
    [[ -z "$question" || "$question" == " " ]] && return
    
    # Remove leading space if present  
    question="${question# }"
    
    # Skip if still empty
    [[ -z "$question" ]] && return
    
    # Show option to ask Claude the question
    echo "🤖 Ask Claude: '$question'"$'\t'"🤖 Ask Claude: '$question'"$'\t'"ask_claude:$question"
}

handle_selection() {
    local selected="$1"
    local has_hyprctl=false
    command -v hyprctl >/dev/null 2>&1 && has_hyprctl=true
    
    # Check if it's an AI question request
    if [[ "$selected" =~ ^ask_claude: ]]; then
        # Extract question and ask Claude
        local question="${selected#ask_claude:}"
        
        # Check if Claude CLI is available
        if ! command -v claude >/dev/null 2>&1; then
            if command -v notify-send >/dev/null 2>&1; then
                notify-send "AI Assistant" "Claude CLI not found. Please install claude-cli."
            fi
            return 1
        fi
        
        if $has_hyprctl; then
            hyprctl dispatch exec "alacritty -e bash -c 'source ~/.bashrc; echo \"🤖 Asking Claude: $question\"; echo; claude -p \"$question\"; exec bash'"
        else
            alacritty -e bash -c "source ~/.bashrc; echo '🤖 Asking Claude: $question'; echo; claude -p '$question'; exec bash" >/dev/null 2>&1 &
        fi
        return 0
    fi
    
    return 1
}