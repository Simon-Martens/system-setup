#!/bin/bash

# Check for non-interactive mode
NON_INTERACTIVE=false
if [[ "$1" == "--non-interactive" ]]; then
    NON_INTERACTIVE=true
fi

# Copy over Omarchy configs
cp -R ~/.local/share/omarchy/config/* ~/.config/

# Ensure application directory exists for update-desktop-database
mkdir -p ~/.local/share/applications

# Use default bashrc from Omarchy
if [[ "$NON_INTERACTIVE" == true ]]; then
    ~/.local/share/omarchy/scripts/generate-rc.sh bash --non-interactive
else
    ~/.local/share/omarchy/scripts/generate-rc.sh bash
fi

# Login directly as user, rely on disk encryption + hyprlock for security
# Skip sudo commands in non-interactive mode
if [[ "$NON_INTERACTIVE" == false ]]; then
    sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
    sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf >/dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM
EOF
fi

# Set common git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global pull.rebase false

# WARNING 
# You'll need to import the appropriate signing key
git config --global user.signingkey 61F5BD22CF3388F9

# Set identification from install inputs
if [[ -n "${OMARCHY_USER_NAME//[[:space:]]/}" ]]; then
  git config --global user.name "$OMARCHY_USER_NAME"
else
	git config --global user.name "Simon Martens"
fi

if [[ -n "${OMARCHY_USER_EMAIL//[[:space:]]/}" ]]; then
  git config --global user.email "$OMARCHY_USER_EMAIL"
else
	git config --global user.email simon.martens@mailbox.org
fi

# Set default XCompose that is triggered with CapsLock
tee ~/.XCompose >/dev/null <<EOF
include "%H/.local/share/omarchy/default/xcompose"

# Identification
<Multi_key> <space> <n> : "$OMARCHY_USER_NAME"
<Multi_key> <space> <e> : "$OMARCHY_USER_EMAIL"
EOF
