#!/bin/bash

################################# SYSTEM PACKAGES & REQUIREMENTS ###########################################################################
sudo apt update
sudo apt upgrade -y
sudo apt install -y \
	tmux curl wget wl-clipboard ninja-build gettext cmake unzip xsel git vlc gnome-shell-extension-manager \
	ripgrep fzf gzip htop make diffutils g++ gettext mono-devel dirmngr gpg curl gawk libreoffice autoconf \
	m4 libncurses5-dev libwxgtk3.2-dev libwxgtk-webview3.2-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev \
	libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk fd-find gnome-sushi \
	gnome-tweak-tool gir1.2-gtop-2.0 gir1.2-gtkclutter-1.0 remmina pipx postgresql inotify-tools \
	gnome-weather python3-pip python-is-python3 brightnessctl apt-listchanges \
  build-essential pkg-config autoconf bison clang rustc \
  libssl-dev libreadline-dev zlib1g-dev libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev libjemalloc2 \
  libvips imagemagick libmagickwand-dev mupdf mupdf-tools gir1.2-gtop-2.0 gir1.2-clutter-1.0 \
  redis-tools sqlite3 libsqlite3-0 libmysqlclient-dev libpq-dev postgresql-client postgresql-client-common

