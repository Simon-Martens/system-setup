# Create a desktop launcher for a web app
if command -v helium &> /dev/null; then
	web2app() {
		if [ "$#" -ne 3 ]; then
			echo "Usage: web2app <AppName> <AppURL> <IconURL> (IconURL must be in PNG -- use https://dashboardicons.com)"
			return 1
		fi

		local APP_NAME="$1"
		local APP_URL="$2"
		local ICON_URL="$3"
		local ICON_DIR="$HOME/.local/share/applications/icons"
		local DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME}.desktop"
		local ICON_PATH="${ICON_DIR}/${APP_NAME}.png"

		mkdir -p "$ICON_DIR"

		if ! curl -sL -o "$ICON_PATH" "$ICON_URL"; then
			echo "Error: Failed to download icon."
			return 1
		fi

		cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Name=$APP_NAME
Comment=$APP_NAME
Exec=helium --new-window --ozone-platform=wayland --app="$APP_URL" --name="$APP_NAME" --class="$APP_NAME"
Terminal=false
Type=Application
Icon=$ICON_PATH
StartupNotify=true
EOF

		chmod +x "$DESKTOP_FILE"
	}

	web2app-remove() {
		if [ "$#" -ne 1 ]; then
			echo "Usage: web2app-remove <AppName>"
			return 1
		fi

		local APP_NAME="$1"
		local ICON_DIR="$HOME/.local/share/applications/icons"
		local DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME}.desktop"
		local ICON_PATH="${ICON_DIR}/${APP_NAME}.png"

		rm "$DESKTOP_FILE"
		rm "$ICON_PATH"
	}

  web2app "WhatsApp" https://web.whatsapp.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/whatsapp.png
  web2app "ChatGPT" https://chatgpt.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/chatgpt.png
  web2app "DeepSeek" https://chat.deepseek.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/deepseek.png
  web2app "GitHub" https://github.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/github-light.png
	# Sigh
  web2app "Teams" https://teams.microsoft.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/microsoft-teams.png
  web2app "Outlook" https://outlook.office.com/mail/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/microsoft-outlook.png
	web2app "OneDrive" https://tsstiftung-my.sharepoint.com https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/microsoft-onedrive.png
	web2app "Gemini" https://gemini.google.com https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-gemini.png
	web2app "Claude" https://claude.ai https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/claude-ai.png
	web2app "TouTube Music" https://music.youtube.com https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/youtube-music.png
	web2app "Telegram" https://web.telegram.org https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/telegram.png
  web2app "Microsft Admin Center" https://admin.microsoft.com https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/microsoft-365-admin-center.png

fi
