# Auto-start tmux for interactive shells.
#
# Conditions:
# - only in an interactive shell
# - only when not already inside tmux
# - only when tmux is installed
#
# Behavior:
# - attach to session "home" if it exists
# - otherwise create session "home" starting in ~
# if [[ $- == *i* ]] && [[ -z "$TMUX" ]] && command -v tmux >/dev/null 2>&1; then
#     tmux new-session -A -s home -c "$HOME"
# fi
