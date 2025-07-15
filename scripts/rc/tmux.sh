function n() {
    if [ -z "$1" ]; then
        echo "Usage: n <session_name|directory>"
        return 1
    fi

    # If argument is a directory, use basename as session name
    if [ -d "$1" ]; then
        session_name=$(basename "$1")
        work_dir=$(realpath "$1")
    else
        session_name="$1"
        work_dir="$PWD"
    fi

    if [ -n "$TMUX" ]; then
        tmux has-session -t "$session_name" 2>/dev/null
        if [ $? != 0 ]; then
            tmux new-session -d -s "$session_name" -c "$work_dir"
        fi
        tmux switch-client -t "$session_name"
    else
        echo "Not inside tmux."
        return 1
    fi
}

if [ -d "$HOME/source/tmux-session-wizard-rewired/bin" ]; then
		export PATH="$HOME/source/tmux-session-wizard-rewired/bin:$PATH"
elif [ -d "$HOME/.tmux/plugins/tmux-session-wizard-rewired/bin" ]; then
		export PATH="$HOME/.tmux/plugins/tmux-session-wizard-rewired/bin:$PATH"
fi

