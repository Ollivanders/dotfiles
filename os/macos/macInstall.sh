#!/usr/local/bin/zsh
#
# Downloads and configures iterm and updates base software

if test ! "$(uname)" = "Darwin"; then
  exit 0
fi

# TODO Configure adding automator and scripts

cp -R ~/.dotfiles/os/macos/automator/Services/ ~/Library/Services/

# The Brewfile handles Homebrew-based app and library installs, but there may
# still be updates and installables in the Mac App Store. There's a nifty
# command line interface to it that we can use to just install everything, so
# yeah, let's do that.

brew reinstall cask

#------------------------------------------------------------------------------
# Install iTerm2 and include profile
echo "installing terminal iTerm2"
brew list --cask iterm2 || brew install --cask iterm2
cp ./iTerm2/Default.json '~/Library/Application Support/iTerm2/DynamicProfiles/itermprofiles.json'

#------------------------------------------------------------------------------
# Update Software
echo "› sudo softwareupdate -i -a"
sudo softwareupdate -i -a
#softwareupdate --all --install --force
