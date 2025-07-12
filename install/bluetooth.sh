# Install bluetooth controls
yay -S --noconfirm --needed pipewire pipewire-pulse pipewire-alsa pipewire-audio wireplumber ffmpeg gstreamer gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav gstreamer-vaapi bluetui wiremix

# Turn on bluetooth by default
sudo systemctl enable --now bluetooth.service
systemctl --user enable --now pipewire pipewire-pulse wireplumber
