if [[ $- == *i* ]] && command -v zoxide &> /dev/null; then
  eval "$(zoxide init bash)"
	alias cd="zd"
	zd() {
		if [ $# -eq 0 ]; then
			builtin cd ~ && return
		elif [ -d "$1" ]; then
			builtin cd "$1"
		else
			z "$@" && printf " \U000F17A9 " && pwd || echo "Error: Directory not found"
		fi
	}

	if command -v fzf &> /dev/null; then
		function c() {
			if [ $# -eq 0 ]; then
				local selected_dir
				selected_dir="$(zoxide query -l | fzf --reverse --preview 'ls -alh {}')"
				if [ -n "$selected_dir" ]; then
					cd "$selected_dir"
				fi
			elif [ -d "$1" ]; then
				builtin cd "$1"
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
					builtin cd "$matches" && printf " \U000F17A9 " && pwd
				else
					local selected_dir
					selected_dir="$(echo "$matches" | fzf --reverse --preview 'ls -alh {}' --query "$1")"
					if [ -n "$selected_dir" ]; then
						cd "$selected_dir"
					fi
				fi
			fi
		}
	fi

fi


