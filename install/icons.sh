#!/bin/bash

rm -rf /tmp/dashboard-icons
if [ ! -d "/tmp/dashboard-icons" ]; then
	git clone --branch main --depth 1 https://github.com/homarr-labs/dashboard-icons /tmp/dashboard-icons
fi 
if [ -d "/tmp/dashboard-icons" ]; then
	mkdir -p "$HOME/.local/share/icons/hicolor/48x48/apps"
	mv /tmp/dashboard-icons/png/* "$HOME/.local/share/icons/hicolor/48x48/apps/"
	gtk4-update-icon-cache "$HOME/.local/share/icons/hicolor" &> /dev/null || true
fi
