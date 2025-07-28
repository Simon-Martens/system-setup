#!/bin/sh

# Remove snaps completely from Ubuntu
# Tested on Ubuntu 24.04

while [ $(snap list | wc -l) -gt 1 ]; do
  for p in $(snap list | awk 'NR>1 {print $1}'); do
    sudo snap remove "$p" --purge
  done
done

sudo systemctl stop snapd
for m in /snap/core/*; do
   sudo umount $m
done

sudo apt purge -y snapd

rm -rf ~/snap
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
sudo rm -rf /var/cache/snapd

# The following command will make sure snapd does not get installed again as a dependency.

sudo apt-mark hold snapd
