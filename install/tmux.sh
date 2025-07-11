if ! command -v tmux &>/dev/null; then
  yay -S --noconfirm --needed tmux
fi

# Tmux setup
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
