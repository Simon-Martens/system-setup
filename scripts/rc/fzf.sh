if [[ $- == *i* ]] && command -v fzf &> /dev/null; then
  if [[ -f /usr/share/bash-completion/completions/fzf ]]; then
    source /usr/share/bash-completion/completions/fzf
  fi

	function f() {
		cd "$(fd . '/' --type d --exclude={proc,.git,.cache,node_modules} | fzf --preview 'ls -l {}')"
	}
fi
