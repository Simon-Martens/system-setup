#!/usr/bin/env bash

sudo dnf upgrade --refresh

sudo dnf copr enabpe lionheartp/Hyprland # Gives hyprland & utilse. Isntalls kitty, wofi, brightnessctl, playerctl, uwsm and other stuff as soft deps.
sudo dnf copr enable avengemedia/dms # Gives DankMaterialShell (stable)
sudo dnf copr enable jdxcode/mise # Gives mise
sudo dnf copr enable imput/helium # gives helium
sudo dnf install alacritty nvim atuin zoxide stow mise helium hyprland mako dms abduco dvtm


systemctl enable --user dms
mise install
