if [[ $- == *i* ]] && command -v zoxide &> /dev/null; then
	eval "$(zoxide init bash)"
	alias cd="zd"
	zd() {
		if [ $# -eq 0 ]; then
			builtin cd ~ || return
		elif [ -d "$1" ]; then
			builtin cd "$1" || return
		else
			if ! z "$@"; then
				echo "Error: Directory not found"
				return 1
			fi
			printf " \U000F17A9 "
			pwd
		fi

		# The custom cd wrapper bypasses mise's cd function, so run its hook here.
		if declare -F _mise_hook_chpwd >/dev/null; then
			_mise_hook_chpwd
		fi
	}

	if command -v fzf &> /dev/null; then
		function c() {
			if [ $# -eq 0 ]; then
				local selected_dir
				selected_dir="$(zoxide query -l | fzf --reverse --preview 'ls -alh {}')"
				if [ -n "$selected_dir" ]; then
					zd "$selected_dir"
				fi
			elif [ -d "$1" ]; then
				zd "$1"
			else
				local matches
				matches=$(zoxide query -l "$1")

				if [ -z "$matches" ]; then
					echo "Error: No directory found matching '$1'"
					return 1
				fi

				local num_matches
				num_matches=$(echo "$matches" | wc -l)

				if [ "$num_matches" -eq 1 ]; then
					zd "$matches" && printf " \U000F17A9 " && pwd
				else
					local selected_dir
					selected_dir="$(echo "$matches" | fzf --reverse --preview 'ls -alh {}' --query "$1")"
					if [ -n "$selected_dir" ]; then
						zd "$selected_dir"
					fi
				fi
			fi
		}
	fi

fi

