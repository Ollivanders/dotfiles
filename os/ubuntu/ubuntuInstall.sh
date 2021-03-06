#!/bin/bash
#
# installation of base Ubuntu appications and settigns

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

apt-get $APT_NON_INTERACTIVE_OPTIONS install update
apt-get $APT_NON_INTERACTIVE_OPTIONS install upgrade

##############################################################################
# Terminal
##############################################################################
apt-get $APT_NON_INTERACTIVE_OPTIONS install terminator
cp $HOME/.dotfiles/os/ubuntu/terminator/config $HOME/.config/terminator/config

##############################################################################
# Applications
##############################################################################
snap install --classic code

apt-get install $APT_NON_INTERACTIVE_OPTIONS /
curl /
nano /
vim

# install chrome
read -p "Would you like to download chrome .deb (y/n)?" ANS
if [ "$ANS" = "y" ]; then
  curl "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -O /tmp/chrome.deb
  dpkg -i /tmp/chrome.deb
  sudo apt-get install $APT_NON_INTERACTIVE_OPTIONS -f
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
