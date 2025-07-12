if ! command -v tmux &>/dev/null; then
  yay -S --noconfirm --needed tmux
fi

# Tmux setup
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
