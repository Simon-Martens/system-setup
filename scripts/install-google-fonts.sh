#!/usr/bin/env bash

set -euo pipefail

archive_url="https://github.com/google/fonts/archive/refs/heads/main.tar.gz"
font_root="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
install_dir="$font_root/google-fonts"
staging_dir="$font_root/.google-fonts.new.$$"
backup_dir="$font_root/.google-fonts.old.$$"
download_dir="$(mktemp -d)"

cleanup() {
  local status=$?
  trap - EXIT INT TERM

  rm -rf "$download_dir" "$staging_dir"
  if [[ -d "$backup_dir" ]]; then
    if [[ ! -e "$install_dir" ]]; then
      mv "$backup_dir" "$install_dir"
    else
      rm -rf "$backup_dir"
    fi
  fi

  exit "$status"
}
trap cleanup EXIT INT TERM

for command in curl tar find cp fc-cache; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf 'Required command not found: %s\n' "$command" >&2
    exit 1
  fi
done

printf 'Downloading the Google Fonts repository...\n'
curl --fail --location --retry 3 --progress-bar "$archive_url" |
  tar -xz -C "$download_dir"

source_dir="$download_dir/fonts-main"
if [[ ! -d "$source_dir" ]]; then
  printf 'The downloaded archive has an unexpected structure.\n' >&2
  exit 1
fi

mkdir -p "$font_root" "$staging_dir"

collections=()
for collection in apache cc-by-sa ofl ufl; do
  if [[ -d "$source_dir/$collection" ]]; then
    collections+=("$collection")
  fi
done

if (( ${#collections[@]} == 0 )); then
  printf 'No Google Fonts collections were found in the archive.\n' >&2
  exit 1
fi

printf 'Preparing fonts for installation...\n'
(
  cd "$source_dir"
  find "${collections[@]}" -type f \
    \( -iname '*.ttf' -o -iname '*.otf' -o -iname '*.ttc' -o -iname '*.otc' \) \
    -exec cp --parents -t "$staging_dir" -- {} +
)

font_count="$(find "$staging_dir" -type f | wc -l)"
if (( font_count == 0 )); then
  printf 'No font files were found in the archive.\n' >&2
  exit 1
fi

rm -rf "$backup_dir"
if [[ -e "$install_dir" ]]; then
  mv "$install_dir" "$backup_dir"
fi
mv "$staging_dir" "$install_dir"
rm -rf "$backup_dir"

printf 'Rebuilding the font cache...\n'
fc-cache -f

printf 'Installed %s Google Fonts into %s\n' "$font_count" "$install_dir"
