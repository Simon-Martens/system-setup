# .bashrc
# .bash_env is sourced if the command requires a non-interactive shell
export BASH_ENV="~/.bash_env"

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

if [ -d "$HOME/scripts/bashrc" ]; then
    for file in "$HOME/scripts/bashrc/"*.sh; do				
        if [ -r "$file" ]; then
					echo "Loading: $file"
					. "$file"
				fi
    done
fi

export PATH

### STARTUP
# if command -v fastfetch >/dev/null 2>&1; then
# 	fastfetch
# fi
# if [ -z "$TMUX" ]; then
#     tmux new-session
#     exit
# fi
