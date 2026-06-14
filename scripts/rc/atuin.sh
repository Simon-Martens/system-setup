if [[ $- == *i* ]] && command -v atuin &> /dev/null; then
	if [ -f "$HOME/.atuin/bin/env" ]; then
		. "$HOME/.atuin/bin/env"
	fi
  eval "$(atuin init bash --disable-up-arrow)"
fi

