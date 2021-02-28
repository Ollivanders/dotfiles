APT_NON_INTERACTIVE_OPTIONS=' -yq -o APT::Get::AllowUnauthenticated=yes -o Acquire::Check-Valid-Until=false -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confmiss '

echo "installing terminal terminator"
sudo apt-get $APT_NON_INTERACTIVE_OPTIONS install terminator
cp $HOME/.dotfiles/os/ubuntu/terminator/config $HOME/.config/terminator/config

##############################################################################
# Applications
##############################################################################
sudo snap install --classic code

# install chrome
read -p "Download chrome .deb (y/n)?" CONT
if [ "$CONT" = "y" ]; then
  wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -O ~/downloads/chrome.deb
  dpkg -i ~/downloads/chrome.deb
  apt install -f
else
  echo "no chrome";
fi

##############################################################################
# Presentation
##############################################################################
# Paper icon config
sudo add-apt-repository ppa:snwh/ppa
sudo apt-get update
sudo apt-get install paper-icon-theme

# Configure background

# Configure dock favourites

# Configure 