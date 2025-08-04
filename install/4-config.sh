#!/bin/bash

# Check for non-interactive mode
NON_INTERACTIVE=false
if [[ "$1" == "--non-interactive" ]]; then
    NON_INTERACTIVE=true
fi

SOURCE_DIR="$HOME/.local/share/omarchy/config"
DEST_DIR="$HOME/.config"
echo "--- Starting automatic deployment from '$SOURCE_DIR' to '$DEST_DIR' ---"

# Loop through all files and folders in the source directory.
for source_path in "$SOURCE_DIR"/*; do
    [ -e "$source_path" ] || continue
    item_name=$(basename "$source_path")
    dest_path="$DEST_DIR/$item_name"

    echo "--- Deploying '$item_name' ---"

    rm -rf "$dest_path"
    cp -r "$source_path" "$dest_path"
    
    echo "✅ Deployed '$item_name'."
done

echo "🎉 Deployment complete."

# Generate the .bashrc file
if [[ "$NON_INTERACTIVE" == true ]]; then
    ~/.local/share/omarchy/scripts/generate-rc.sh bash --non-interactive
else
    ~/.local/share/omarchy/scripts/generate-rc.sh bash
fi

# Ensure application directory exists for update-desktop-database
mkdir -p ~/.local/share/applications

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
