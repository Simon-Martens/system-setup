#!/usr/bin/env bash

set -euo pipefail

repository_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
config_root="${XDG_CONFIG_HOME:-$HOME/.config}"
dconf_source="$repository_root/dotfiles/gnome/.dconf"
dconf_target="$config_root/dconf"
dconf_backup="$config_root/dconf.binary.bak"

mkdir -p -- "$config_root"
stow --dir "$repository_root/dotfiles" --target "$HOME" gnome

if [[ -L "$dconf_target" ]]; then
  if [[ "$(readlink -f -- "$dconf_target")" != "$dconf_source" ]]; then
    echo "Refusing to replace unrelated symlink: $dconf_target" >&2
    exit 1
  fi
elif [[ -e "$dconf_target" ]]; then
  if [[ -e "$dconf_backup" || -L "$dconf_backup" ]]; then
    echo "Refusing to overwrite existing backup: $dconf_backup" >&2
    exit 1
  fi

  mv -- "$dconf_target" "$dconf_backup"
  echo "Preserved the previous dconf database at $dconf_backup"
fi

if [[ ! -e "$dconf_target" && ! -L "$dconf_target" ]]; then
  ln -s -- "$dconf_source" "$dconf_target"
fi

echo "GNOME dconf now uses tracked text settings from $dconf_source/user.txt"
echo "Log out and back in to activate DCONF_PROFILE for the graphical session."
