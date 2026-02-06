#!/bin/bash

# Niri extras and dependencies

yay -S --noconfirm --needed \
  xwayland-satellite \
  xdg-desktop-portal-gnome \
  xdg-desktop-portal-gtk \
  matugen \
  cava \
  qt6-multimedia-ffmpeg \
  dsearch-bin

# Enable dsearch service
systemctl --user enable --now dsearch
