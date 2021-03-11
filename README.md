<img src="./docs/images/osSwirl.png" alt="drawing" style="width:300px;float: right"/>

# The Dankest Dotfiles

Many of us have tapped into the chaotic good energy created from custom preferences, However keeping these bad bois consistent and shared between your work setups, virtual machines, raspberry pi, macbook, clusters, whatever Docker is, and the computer that you let your cat borrow in exchange for him doing the washing up, is not only challenging but damn frustrating when you can't rely on your beautiful alias's to do their job. 

So here collected, is a ubuntu/mac advanced developer setup for maintaining such a setup.

Your system crashes ---> a tear starts to trickle down your face as dark thoughts of setting up your system again enter your brain. A mental tally of the number of times you are going to have to write apt install begins to only be reminded every single time you do it that you forgot to write sudo. 

Swipe that misery away, reinstall from here and you will be frolicking with unicorns again.
# Description and Features

- Installation organised by application/OS
- anything titled "install.sh" will be run on start up
- Configures with Windows (Powerline still experimental but full WSL support), MacOS and Ubuntu

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.

- **topic/\*.bzsh**: Any files ending in `.bzsh` get loaded into your
  environment.
- **topic/path.bzsh**: Any file named `path.bzsh` is loaded first and is
  expected to setup `$PATH` or similar.
- **topic/completion.bzsh**: Any file named `completion.bzsh` is loaded
  last and is expected to setup autocomplete.

- **topic/install.sh**: Any file named `install.sh` is executed when you run `script/install`. To avoid being loaded automatically, its extension is `.sh`, not `.zsh`.
- **topic/\*.symlink**: Any file ending in `*.symlink` gets symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.


# Plugins installed

## ZSH

## Alias finder

## Syntax highlighting 

## 
# Dotfile setup

```
sudo apt-get install git # if needed
git clone https://github.com/Ollivanders/dotfiles.git
./letsgo
```

If you have any troubles, read through: [a relative link][./troubleshooting.md]
# To do

With an ever morphing world, the number of potential contexts installation that could be called from increases as with the ambition of this collection. Multiple private versions of this dotfiles exist for different levels of config (simple setup of aliases only vs full ohmyzzsh configuration), so working is taking place to move this into one unified set. Therefore for now, problems in niche examples are too be expected as streamlining takes place.

- OS specific

  - windows terminal profile config

  - add automator symlink and other mac services configuration
  - add scripts to services by custom keybindings
  - add custom keybindings (transfer from snap to native)

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
  - configure alerts and wallpapers automatically

  - speed up shell loading, shade plugins

QUICK COMPLETELY AUTO SETUP FOR RPI AND VM MANAGEMENT <------------------------------->

- uses bash
- symlinks only

### bash only config

### quick setup

### quick update and install

# Done but still testing

- windows powerline configs (and all windows stuff really)
- check path and completion functionality
- check bash cross compatability
- iTerm coooolourig

# Acknowledgments

Original fork from https://github.com/holman/dotfiles

Inspiration and ideas taken from:

- https://github.com/mathiasbynens/dotfiles/
- https://github.com/paulirish/dotfile
- https://github.com/alrra/dotfiles

