if [ -d "$HOME/.atuin/bin" ]; then
	. "$HOME/.atuin/bin/env"

	[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
	eval "$(atuin init bash --disable-up-arrow)"
fi
