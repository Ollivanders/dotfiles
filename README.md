# The Dankest Dotfiles

Many of us have tapped into the chaotic good energy created from custom preferences, however keeping these bad bois consistent and shared between your work setups, virtual machines, raspberry pi, macbook pro with enhanced graphics and the computer that you let your cat borrow in exchange for him doing the washing up, is not only challenging but damn complicated and frustrating when you can't rely on muscle memory. So here collected, is a ubuntu/mac advanced developer setup.

Your system crashes and a tear starts to trickle down your face at the prospect of setting up your system again. Swipe that misery away, reinstall from here and you will be living the dream once again.

# Description and Features

- Installation organised by application/OS
- \*.symlink will be symlinked to your home directory
- anything titled "install.sh" will be run on start up
- Configures with Windows (Powerline still experimental but full WSL support), MacOS and Ubuntu
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

