if [ -d "/usr/local/go/bin" ]; then
	export PATH=$PATH:/usr/local/go/bin
fi

if [ -d "/usr/local/zig" ]; then
	export PATH=$PATH:/usr/local/zig
fi

if [ -d "$HOME/.nvm" ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

if [ -d "$HOME/gems" ]; then
		export GEM_HOME="$HOME/gems"
		export PATH="$HOME/gems/bin:$PATH"
fi

if [ -d "$HOME/.dotnet" ]; then
	export PATH=$PATH:/home/simon/.dotnet
fi


if [ -d "$HOME/.cargo" ]; then
    . "$HOME/.cargo/env"
fi

if [ -d "$HOME/go/bin" ]; then
    export PATH=$PATH:$HOME/go/bin
fi

if [ -d "$HOME/.local/bin" ]; then
		export PATH=$PATH:$HOME/.local/bin
fi

if [ -d "$HOME/.bun/" ]; then
	export BUN_INSTALL="$HOME/.bun"
	export PATH="$BUN_INSTALL/bin:$PATH"
fi

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

