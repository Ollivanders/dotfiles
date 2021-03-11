#!/bin/bash
#
# installation of base Ubuntu appications and settings

export DEBIAN_FRONTEND=noninteractive

QUICK=false
APT_NON_INTERACTIVE_OPTIONS=' -yq -o APT::Get::AllowUnauthenticated=yes -o Acquire::Check-Valid-Until=false -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confmiss '

while [[ $# -gt 0 ]]; do
  case "$1" in
  "-q" | "--quick")
    QUICK=true
    ;;
  *)
    echo "Unknown arg: $1" >>/dev/stderr
    exit
    ;;
  esac
  shift
done

sudo apt-get $APT_NON_INTERACTIVE_OPTIONS install update
sudo apt-get $APT_NON_INTERACTIVE_OPTIONS install upgrade

##############################################################################
# Terminal
##############################################################################
if [[ $QUICK = false ]]; then
  sudo apt-get $APT_NON_INTERACTIVE_OPTIONS install terminator
  cp $HOME/.dotfiles/os/ubuntu/terminator/config $HOME/.config/terminator/config
fi

##############################################################################
# Applications
##############################################################################
if [[ $QUICK = false ]]; then
  snap install --classic code
  sudo apt-get install $APT_NON_INTERACTIVE_OPTIONS /
  npm \
    nodejs
fi
sudo apt-get install $APT_NON_INTERACTIVE_OPTIONS /
curl /
nano

# install chrome
if [[ $QUICK = false ]]; then
  read -p "Would you like to download chrome .deb (y/n)?" ANS
  if [ "$ANS" = "y" ]; then
    curl "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -O /tmp/chrome.deb
    dpkg -i /tmp/chrome.deb
    sudo apt-get install $APT_NON_INTERACTIVE_OPTIONS -f
  fi
fi

##############################################################################
# Presentation
##############################################################################
# Paper icon config
# sudo add-apt-repository ppa:snwh/ppa
# sudo apt-get update
# sudo apt-get install paper-icon-theme

# Configure background

# Configure dock favourites, size and position

# Configure settings
