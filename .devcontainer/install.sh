#!/bin/sh
set -e

git clone https://github.com/muryoimpl/devcontainer-dotfiles.git ~/devcontainer-dotfiles
cd ~/devcontainer-dotfiles
./install.sh
