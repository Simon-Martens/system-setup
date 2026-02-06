#!/bin/bash

# DankMaterialShell Greeter Installation

set -e

echo "Installing DankMaterialShell (DMS) Greeter..."

# Install from AUR
yay -S --noconfirm --needed greetd-dms-greeter-git

# Install ACL package for theme syncing
yay -S --noconfirm --needed acl

# Verify dms command is available
if ! command -v dms &>/dev/null; then
    echo "ERROR: dms command not found. Is DankMaterialShell installed?"
    exit 1
fi

echo "Enabling DMS greeter..."
dms greeter enable

echo "Syncing greeter with user theme..."
dms greeter sync

echo ""
echo "DMS Greeter installation complete!"
echo ""
echo "IMPORTANT: You need to log out and log back in for group membership changes to take effect."
echo "After logging back in, run: dms greeter status"
