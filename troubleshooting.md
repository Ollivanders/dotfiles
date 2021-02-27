# Troubleshooting 
## oh-ny-zsh or powerline not present

This means the git submodule has not been run and therefore the projects are not present

```
git submodule init
git submodule update
```

If that simply won't connect, try running ${DOTFILES}/bin/grsm (git remove submodules) and try again 

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

Otherwise attempt to install the fonts manually:
```  
sudo apt-get update
sudo apt-get install fonts-font-awesome
sudo apt-get install fonts-powerlinew
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

  - vscode sync
  - terminator config

- shell

  - make overwrite on individual configs optional e.g. own p10k zsh config
  - optional cli configure of ohmyzsh

  - option to do zsh installation automatically
  - automatic font installation

- Main setup and handling
  - improved print output control -> inform user of what is about to happen and give more warnings if dangerous, better colouring
  - update all packages script simplify
  - config file with default responses to prompts in letsgo.sh

### bash only config

### quick setup

### quick update

# Done but still testing

- windows powerline configs (and all windows stuff really)
- check path and completion functionality
- check bash cross compatability
- iTerm coooolourig

