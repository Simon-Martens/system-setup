# Background Image downloading
BACKGROUNDS_DIR=~/.config/system-setup/backgrounds/

download_background_image() {
  local url="$1"
  local path="$2"
  gum spin --title "Downloading $url as $path..." -- curl -sL -o "$BACKGROUNDS_DIR/$path" "$url"
}

for t in ~/.local/share/system-setup/themes/*; do
	if [[ -f "$t/backgrounds.sh" ]]; then	
	source "$t/backgrounds.sh"
	fi
done
# Use dark mode for QT apps too (like kdenlive)
sudo pacman -S --noconfirm kvantum-qt5

# Prefer dark mode everything
sudo pacman -S --noconfirm gnome-themes-extra # Adds Adwaita-dark theme
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

# Setup theme links
rm -rf ~/.config/system-setup/themes
mkdir -p ~/.config/system-setup/themes
for f in ~/.local/share/system-setup/themes/*; do ln -s "$f" ~/.config/system-setup/themes/; done

# Set initial theme
mkdir -p ~/.config/system-setup/current
ln -snf ~/.config/system-setup/themes/tokyo-night ~/.config/system-setup/current/theme
source ~/.local/share/system-setup/themes/tokyo-night/backgrounds.sh
ln -snf ~/.config/system-setup/backgrounds/tokyo-night ~/.config/system-setup/current/backgrounds
ln -snf ~/.config/system-setup/current/backgrounds/1-Pawel-Czerwinski-Abstract-Purple-Blue.jpg ~/.config/system-setup/current/background

# Set specific app links for current theme
ln -snf ~/.config/system-setup/current/theme/wofi.css ~/.config/wofi/style.css
ln -snf ~/.config/system-setup/current/theme/neovim.lua ~/.config/nvim/lua/theme.lua
mkdir -p ~/.config/btop/themes
ln -snf ~/.config/system-setup/current/theme/btop.theme ~/.config/btop/themes/current.theme
mkdir -p ~/.config/mako
ln -snf ~/.config/system-setup/current/theme/mako.ini ~/.config/mako/config
