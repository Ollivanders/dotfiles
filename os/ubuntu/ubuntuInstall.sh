APT_NON_INTERACTIVE_OPTIONS=' -yq -o APT::Get::AllowUnauthenticated=yes -o Acquire::Check-Valid-Until=false -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confmiss '

echo "installing terminal terminator"
sudo apt-get $APT_NON_INTERACTIVE_OPTIONS install terminator
cp $HOME/.dotfiles/os/ubuntu/terminator/config $HOME/.config/terminator/config

sudo snap install --classic code