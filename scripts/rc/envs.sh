# Editor used by CLI
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"


# GO
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

# Zig
export PATH=$PATH:/usr/local/zig

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Ruby
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

# Dotnet
export PATH=$PATH:/home/simon/.dotnet

# NVM
if [ -d "$HOME/.nvm" ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Rust
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# Additional and custom executable paths
PATH=$HOME/.local/bin:$HOME/bin:$PATH
