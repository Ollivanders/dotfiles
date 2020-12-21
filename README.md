# Dotfile setup
* Make sure zsh is installed and configured
* Clone the project where ever
* run script/bootstrap

## Configure zsh on linux
```
sudo apt-get install zsh
brew install zsh

chsh -s /bin/zsh <user>
chsh -s /bin/zsh root
chsh -s /bin/zsh
chsh -s $(which zsh)
```
# Issues

## oh-ny-zsh or powerline not present 
This means the git submodule has not been run and therefore the projects are not present
```
git submodule init
git submodule update
```

## Compliant directories

```
sudo chmod -R 755 /usr/local/share/zsh
sudo chown -R root:staff /usr/local/share/zsh
```

## Fonts
Run the below to configure the font and then run script/bootstrap again to re-init the .zshrc directory from the dotfiles project. This is by far the easiest solution and is recommended 
```
p10k configure
```

```
sudo apt-get install update
sudo apt-get install fonts-font-awesome
sudo apt-get install fonts-powerline
```

Direct installations of the fonts:
* https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
* https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
* https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
* https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

MesloGS NF might be required as well. For some terminals such as windows terminal or termintaor, configuration of this can be done in settings/preferences for the app and the font library specified.

## Font not appearing in vscode
add the following to settings.json 
```
    "terminal.integrated.fontFamily": "MesloLGS NF",
    "terminal.integrated.rendererType": "canvas",
    "terminal.integrated.shell.osx": "/bin/zsh"
```

# To do
* windows terminal profile config 
* terminator config 
* automatic font installation 
* vscode sync and dotfiles integration 


# Acknowledgments

Based off https://github.com/holman/dotfiles

Inspiration taken from:
- https://github.com/mathiasbynens/dotfiles/
- https://github.com/paulirish/dotfile
- https://github.com/alrra/dotfiles
