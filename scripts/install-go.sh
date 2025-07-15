#!/bin/bash

# Install latest go version
cd ~/Downloads
CURRENT_VERSION=$(go version | awk '{print $3}')
VERSION=$(curl -s https://go.dev/dl/?mode=json | jq -r '.[0].version')

echo "Current Go version: $CURRENT_VERSION"

if [ "$CURRENT_VERSION" = "$VERSION" ]; then
  echo "Go is already up to date!"
else
  echo "Downloading Go $VERSION..."
  wget -q https://go.dev/dl/$VERSION.linux-amd64.tar.gz

  echo "Removing old Go version..."
  sudo rm -rf /usr/local/go

  echo "Installing..."
  sudo tar -C /usr/local -xzf $VERSION.linux-amd64.tar.gz

  echo "Cleaning up..."
  rm $VERSION.linux-amd64.tar.gz

  echo "Go $VERSION installed!"
fi

export PATH=$PATH:/usr/local/go/bin

go install github.com/air-verse/air@latest
