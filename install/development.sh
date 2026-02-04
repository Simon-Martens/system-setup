#!/bin/bash

# Development tools and languages

echo "Installing development tools and languages..."

# Core development tools from Arch repos
yay -S --noconfirm --needed \
  rustup clang llvm mise \
  imagemagick \
  mariadb-libs postgresql-libs \
  github-cli \
  lazygit lazydocker-bin

# Rust
rustup install nightly

# Python
yay -S --noconfirm python
curl -LsSf https://astral.sh/uv/install.sh | sh

# Node.js
if ! command -v node &>/dev/null; then
	yay -S --needed --noconfirm nodejs npm
fi

# Go
if ! command -v go &>/dev/null; then
  yay -S --noconfirm --needed go 
fi
go install github.com/air-verse/air@latest

# Bun
if ! command -v bun &>/dev/null; then
	curl -fsSL https://bun.com/install | bash
fi

echo "Development tools installation complete!"
