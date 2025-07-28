#!/bin/bash

# Install nvm & node
cd ~/source
git clone git@github.com:nvm-sh/nvm.git
cd nvm
export PROFILE=/dev/null
./install.sh
export PROFILE=
cd
source ~/.bashrc
nvm install node
source ~/.bashrc

npm install -g @fsouza/prettierd
