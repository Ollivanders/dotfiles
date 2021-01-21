APT_NON_INTERACTIVE_OPTIONS=' -yq -o APT::Get::AllowUnauthenticated=yes -o Acquire::Check-Valid-Until=false -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confmiss '

apt-get $APT_NON_INTERACTIVE_OPTIONS update
apt-get $APT_NON_INTERACTIVE_OPTIONS upgrade
apt-get $APT_NON_INTERACTIVE_OPTIONS autoremove
apt-get $APT_NON_INTERACTIVE_OPTIONS clean