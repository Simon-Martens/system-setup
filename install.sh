#!/usr/bin/env bash

sudo dnf upgrade --refresh

sudo dnf copr enable lionheartp/Hyprland # Gives hyprland & utilse. Isntalls kitty, wofi, brightnessctl, playerctl, uwsm and other stuff as soft deps.
sudo dnf copr enable avengemedia/dms # Gives DankMaterialShell (stable)
sudo dnf copr enable jdxcode/mise # Gives mise
sudo dnf copr enable imput/helium # gives helium
sudo dnf install btop alacritty nvim atuin zoxide stow mise helium hyprland hyprland-guiutils mako dms dcal dms-greeter tmux fd dsearch --refresh -y

mise install # Installl all programming utilities and packages

systemctl enable --user dms # Desktoip (Dank Material Shell) 
systemctl enable --user dsearch # Search utility for DMS

# Then the user might:
# - install webapps (through scripts)
# - stow directory/ in dotfiles
