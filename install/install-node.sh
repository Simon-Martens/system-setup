#!/bin/bash

# Install nvm & node
mkdir ~/source
git clone git@github.com:nvm-sh/nvm.git ~/source/nvm
export PROFILE=/dev/null
~/source/nvm/install.sh
export PROFILE=
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install node
source ~/.bashrc

npm install -g @fsouza/prettierd
