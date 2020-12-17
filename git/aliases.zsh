# Use `hub` as our git wrapper:
#   http://defunkt.github.com/hub/
hub_path=$(which hub)
if (( $+commands[hub] ))
then
  alias git=$hub_path
fi

# The rest of my fun git aliases
alias g='git'
alias glpp='git pull --prune'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push origin HEAD'

# Remove `+` and `-` from start of diff lines; just rely upon color.
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'

alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gcb='git copy-branch-name'
alias gb='git branch'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias gac='git add -A && git commit -m'
alias ge='git-edit-new'

alias ga='add'
alias gap='add -p'
alias gc='commit --verbose'
alias gca='commit -a --verbose'
alias gcm='commit -m'
alias gcam='commit -a -m'
alias gm='commit --amend --verbose'
alias gd='diff'
alias gds='diff --stat'
alias gdc='diff --cached'
alias gs='status -s'
alias gco='checkout'
alias gcob='checkout -b'

# list branches sorted by last modified
alias gb="!git for-each-ref --sort='-authordate' --format='%(authordate)%09%(objectname:short)%09%(refname)' refs/heads | sed -e 's-refs/heads/--'"
alias g# list aliases
alias gla='!git config -l | grep alias | cut -c 7-'
alias gf='git fetch --all'

alias grao='git remote add origin'
alias gac='!git add . && git commit -am'
alias gpushitgood='git push -u origin --all'
alias gundo-commit='git reset --soft HEAD-1'