##################
# Global Aliases (zsh and bash) 
##################

# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi

alias copyLast='fc -ln -1 | awk '{$1=$1}1' | copy'
alias chm "chmod 777 "

# Reload
alias reload!='. ~/.zshrc' # reload zshrc file
alias reload="exec ${SHELL} -l" # restart shell

# General
alias cls='clear' 
alias pp='python3'
alias rf='rm -rf'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Shortcuts
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/Documents/Projects"
alias ch="cd ~/"

# TODO configure for bash as well (change system directory to .sh or more gen)
