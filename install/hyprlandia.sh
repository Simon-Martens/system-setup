yay -S --noconfirm --needed \
  hyprland hyprshot hyprpicker hyprlock hypridle polkit-gnome hyprland-qtutils \
  wofi waybar swaync swaybg uwsm libnewt \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk

hyprpm update
hyprpm add https://github.com/hyprwm/hyprland-plugins

# Start Hyprland on first session
# echo "[[ -z \$DISPLAY && \$(tty) == /dev/tty1 ]] && exec Hyprland" >~/.bash_profile
