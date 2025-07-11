if [ -z "$OMARCHY_BARE" ]; then
  yay -S --noconfirm --needed \
    gnome-calculator \
    signal-desktop spotify zoom \
    libreoffice obs-studio kdenlive \
    gnome-keyring \
    pinta xournalpp localsend-bin
fi

# Copy over Omarchy applications
source ~/.local/share/omarchy/bin/omarchy-sync-applications || true
