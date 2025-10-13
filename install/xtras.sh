if [ -z "$system-setup_BARE" ]; then
  yay -S --noconfirm --needed \
    gnome-calculator \
    signal-desktop zoom \
    libreoffice \
		telegram-desktop \
    gnome-keyring \
		grc \
    xournalpp localsend-bin
fi

# Copy over system-setup applications
source ~/.local/share/system-setup/bin/system-setup-sync-applications || true
