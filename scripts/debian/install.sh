#!/bin/bash
# Script to setup a new ubuntu dev environment including
#   - prerequisites
#   - neovim (from source)
#   - go, rust, node toolchains
#   - lazygit
#   - zellij
#   - google chrome
#   - keepass2
#   - gnome extensions
#   uvm.

./install-packages.sh
./install-german.sh


############################## PREP
./prereq.sh
./uninstall-snapd.sh
./install-flatpak.sh

############################## LANGUAGES 
cd ~/scripts
./install-rust.sh
cd ~/scripts
./install-node.sh
cd ~/scripts
./install-zig.sh

############################# TOOLS
cd ~/scripts
./setup-tmux.sh
cd ~/scripts
./install-firefox.sh
cd ~/scripts
./install-neovim.sh
cd ~/scripts
./install-ghostty.sh
cd ~/scripts
./install-zoxide.sh
cd ~/scripts
./install-gnome-extensions.sh
cd ~/scripts
./install-lazygit.sh
cd ~/scripts
./install-localsend.sh
cd ~/scripts
./install-chrome.sh
cd ~/scripts
./install-brightness-controller.sh
cd ~/scripts
./install-docker.sh
cd ~/scripts
./install-code.sh

############################ SETUP
cd ~
source ~/.bashrc
fc-cache -f # Refresh font cache
sudo timedatectl set-local-rtc 1 --adjust-system-clock # Avoid time issues with dual-boot setups

