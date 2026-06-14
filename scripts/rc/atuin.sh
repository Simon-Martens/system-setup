if [[ $- == *i* ]] && command -v atuin &> /dev/null; then
	. "$HOME/.atuin/bin/env"
  eval "$(atuin init bash --disable-up-arrow)"
fi

