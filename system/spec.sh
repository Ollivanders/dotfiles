#!/usr/bin/env bash
#
# Settings for both bash and zsh

# Stash your local environment variables in ~/.localrc. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
if [[ -a ~/.localrc ]]; then
  source ~/.localrc
fi

# all of our zsh files
declare -U config_files
config_files=($DOTFILES/**/*.bzsh)

# Remove custom files that handle their own .zsh stuffs, 
# leaving just the goodies in the their .dotfiles directory
for file in "${config_files[@]}"; do
  source $file
done

# add subdirectories from bin to path
for i in $( find $DOTFILES/bin -type d ); do
  PATH=$PATH:$i
done