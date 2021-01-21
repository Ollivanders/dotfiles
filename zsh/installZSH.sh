#!/usr/bin/env bash
#
# Install zsh, in the case where not automatically configured as default shell (depends on apt)

echo "installing zsh"

sudo apt update
sudo apt upgrade
sudo apt install zsh
zsh --version
chsh -s $(which zsh)

echo "You is now having a great time with shell=$SHELL"