# Exit immediately if a command exits with a non-zero status
set -e

# Give people a chance to retry running the installation
trap 'echo "system-setup installation failed! You can retry by running: source ~/.local/share/system-setup/install.sh"' ERR

# Install everything
for f in ~/.local/share/system-setup/install/base/*.sh; do
  echo -e "\nRunning installer: $f"
  source "$f"
done

# Ensure locate is up to date now that everything has been installed
sudo updatedb

./bin/config-install
