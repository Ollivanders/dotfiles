# Settings for both bash and zsh

# Stash your local environment variables in ~/.localrc. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
if [[ -a ~/.localrc ]]; then
  source ~/.localrc
fi

# all of our zsh files
typeset -U config_files
config_files=($DOTFILES/**/*.bzsh)

# Remove custom files that handle their own .zsh stuffs, 
# leaving just the goodies in the their .dotfiles directory
config_files=(${${${config_files:#*/powerlevel10k*}:#*/custom*}:#*/ohmyzsh*})
for file in ${(M)config_files:#*/path.bzsh}
do
  source $file
done

# load everything but the path and completion files # TODO: no longer need to ignore these 
for file in ${${config_files:#*/path.bzsh}:#*/completion.bzsh}
do
  source $file
done
