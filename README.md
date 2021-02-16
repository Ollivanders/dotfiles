# The Dankest Dotfiles (still in experimental for Ubuntu complete auto config)

Many of us have tapped into the chaotic good energy created from custom preferences, however keeping these bad bois consistent and shared between your work setups, virtual machines, raspberry pi, macbook pro with enhanced graphics and the computer that you let your cat borrow in exchange for him doing the washing up, is not only challenging but damn complicated and frustrating when you can't rely on muscle memory. So here collected, is a ubuntu/mac advanced developer setup.

Your system crashes and a tear starts to trickle down your face at the prospect of setting up your system again. Swipe that misery away, reinstall from here and you will be living the dream once again.

# Description

- Installation organised by application/OS
- \*.symlink will be symlinked to your home directory
- anything titled "install.sh" will be run on start up

# Dotfile setup

- will prompt install on mac
- git --version
- sudo apt-get install git

git clone https://github.com/Ollivanders/dotfiles.git
./letsgo -h 


- Make sure zsh is installed and configured
- Clone the project where ever
- run script/bootstrap

```
letsgo -- entry point for dotfile management
  for all your dotfiling needs

Usage: dot [options]

Options:
  -c, --config          Using a config file for setup is an incoming feature
  -e, --edit            Open dotfiles directory for editing
  -h, --help            Show this help message and exit
  -i, --interactive     Choose specific setups to run
  -u, --update          Update previously installed configuration
```

## Things to change

- _export PROJECTS=~/GoogleDrive/Projects_, line 15 in _zsh/zshrc.symlink_, change to your projects directory

# Features

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
sudo apt-get update
sudo apt-get install fonts-font-awesome
sudo apt-get install fonts-powerline
```

Direct installations of the fonts:

- https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
- https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
- https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
- https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

MesloGS NF might be required as well. For some terminals such as windows terminal or termintaor, configuration of this can be done in settings/preferences for the app and the font library specified.

A useful guide for installation in different terminal applications: https://stackoverflow.com/questions/61160791/why-are-font-awesome-characters-not-rendered-or-replaced-on-my-terminal-shell

## Font not appearing in vscode

add the following to settings.json

```
    "terminal.integrated.fontFamily": "MesloLGS NF",
    "terminal.integrated.rendererType": "canvas",
    "terminal.integrated.shell.osx": "/bin/zsh"
```

# To do

With an ever morphing world, the number of potential contexts installation that could be called from increases as with the ambition of this collection. Multiple private versions of this dotfiles exist for different levels of config (simple setup of aliases only vs full ohmyzzsh configuration), so working is taking place to move this into one unified set. Therefore for now, problems in niche examples are too be expected as streamlining takes place.


- OS specific
    - windows terminal profile config
    - add automator symlink and other mac services configuration
    - add scripts to services by custom keybindings
    - look at integrating https://github.com/wting/autojump/blob/master/install.py auto
    - save ubuntu settings (favorites, dock position and size etc. )

- Application specific
    - vscode sync and dotfiles integration
    - terminator config

- shell
    - make overwrite on individual configs optional e.g. own p10k zsh config
    - optional cli configure of ohmyzsh
    - option to do zsh installation automatically
    - automate alias sharing between zsh and bash
    - automatic font installation

- Main setup and handling
    - reorganise bin/dot
    - improved print output control -> inform user of what is about to happen and give more warnings if dangerous, better colouring
    - choice to only use bash and or ignore 
    - update all packages script simplify
    - config file with default responses to prompts in letsgo.sh 

# Acknowledgments

Original fork from https://github.com/holman/dotfiles

Inspiration and ideas taken from:

- https://github.com/mathiasbynens/dotfiles/
- https://github.com/paulirish/dotfile
- https://github.com/alrra/dotfiles
