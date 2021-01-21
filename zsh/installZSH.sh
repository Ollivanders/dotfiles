#!/usr/bin/env bash
#
# Install zsh, in the case where not automatically configured as default shell (depends on apt)

APT_NON_INTERACTIVE_OPTIONS=' -yq -o APT::Get::AllowUnauthenticated=yes -o Acquire::Check-Valid-Until=false -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confmiss '

echo "installing zsh"

sudo apt-get $APT_NON_INTERACTIVE_OPTIONS update
sudo apt-get $APT_NON_INTERACTIVE_OPTIONS install zsh
zsh --version
chsh -s $(which zsh)

echo "You is now having a great time with shell=$SHELL"