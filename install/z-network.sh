#!/bin/bash

if ! command -v nmtui &>/dev/null; then
  yay -S --noconfirm --needed networkmanager
fi

sudo systemctl enable --now NetworkManager
sudo rm /etc/resolv.conf  # Remove if it's not a symlink
sudo ln -sf /run/NetworkManager/resolv.conf /etc/resolv.conf

sudo systemctl disable --now systemd-networkd.socket
sudo systemctl disable --now systemd-networkd.service
sudo systemctl disable --now systemd-resolved.service
sudo systemctl disable --now dhcpcd.service
