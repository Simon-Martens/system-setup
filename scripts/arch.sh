sudo pacman -Syu --noconfirm firefox gnome-extra gnome-tweaks gnome-control-center gdm gnome-shell gnome-backgrounds gnome-settings-daemon gnome-session gnome-terminal gnome-system-monitor gnome-disk-utility gnome-calculator gnome-characters gnome-contacts gnome-font-viewer gnome-logs gnome-menus gnome-screenshot gnome-shell-extensions gnome-themes-extra gvfs gvfs-mtp gvfs-nfs gvfs-smb nautilus networkmanager xdg-user-dirs xdg-utils gnome-power-manager git zoxide bluez bluez-utils pipewire pipewire-pulse pipewire-alsa wireplumber python-pipx wl-clipboard ffmpeg gstreamer gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav gstreamer-vaapi base-devel cmake ninja curl tmux jq gtk4 libadwaita blueprint-compiler gettext power-profiles-daemon hyprland brightnessctl fzf wofi ninja gcc wayland-protocols libjpeg-turbo libwebp libjxl pango cairo pkgconf cmake libglvnd wayland hyprutils hyprwayland-scanner hyprlang hyprpaper xdg-desktop-portal-hyprland qt5-wayland qt6-wayland blueman waybar fzf brightnessctl keepassxc ntfs-3g exfatprogs bat vlc hyprlock udiskie easyeffects hypridle ffmpeg fd 7zip poppler ripgrep imagemagick iio-sensor-proxy python-pip qpdf ghostscript rofi-wayland zsh

gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
gsettings set org.gnome.shell disable-user-extensions false

sudo systemctl enable --now bluetooth.service
sudo systemctl --user enable --now pipewire pipewire-pulse wireplumber
sudo systemctl enable --now power-profiles-daemon

mkdir ~/source
cd ~/source
git clone https://aur.archlinux.org/widevine.git
cd widevine
makepkg -si --noconfirm

cd ~/source
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm

yay -S --noconfirm visual-studio-code-bin google-chrome wlogout

cd ~/scripts
./install-rust.sh
./install-go.sh
./install-node.sh
./install-bun.sh

./setup-tmux.sh
~/.tmux/plugins/tpm/bin/install_plugins all

source ~/.bashrc

./install-neovim.sh
./install-ghostty.sh
./install-dstask.sh

cd ~
git clone git@github.com:Simon-Martens/tasks.git ./.dstask

sudo pacman -S --noconfirm nerd-fonts
yay -S --needed --noconfirm \
ttf-google-fonts-git ttf-ms-fonts ttf-mononoki ttf-iosevka ttf-iosevka-term \
ttf-material-design-icons ttf-font-awesome ttf-weather-icons \
ttf-ubuntu-font-family ttf-hack ttf-clear-sans ttf-roboto ttf-roboto-mono \
ttf-opensans ttf-lato ttf-merriweather ttf-pt-sans ttf-pt-serif \
nerd-fonts-complete

cd ~/scripts
sudo cp -f misc/ssh-agent.service /etc/systemd/user/

systemctl --user enable ssh-agent.service
systemctl --user start ssh-agent.service
systemctl --user enable --now gcr-ssh-agent.socket
systemctl --user enable --now iio-sensor-proxy.service

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
