
if [ "$(uname -s)" == "Darwin" ]
then
  echo "installing terminal iTerm2"
  brew list --cask iterm2 || brew install --cask iterm2
  cp ./iTerm2/Default.json ~/Library/Application Support/iTerm2/DynamicProfiles/itermprofiles.json
else
  echo "installing terminal iTerm2"
  sudo apt-get install terminator
fi