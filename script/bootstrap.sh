#!/usr/bin/env bash
#
# bootstrap installs things.

# ANSI fonts
FONTFAIL='[0;1;31m'
FONTOK='[0;1;32m'
FONTFACE='[0;47;40m'
FONTTITLE='[0;35m'
FONTVAR='[36m'
FONTQUESTION='[0;33m'
FONTANSWER='[0m'
 
cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

set -e

# Parse args
while [[ $# -gt 0 ]]
do
    case "$1" in
                --run)
                    RUN="1"
                    ;;
                --help)
                    echo 'usage: ./script [--dry]'
                    echo
                    echo "  --dry    Don't run the setup commands, just print them."
                    exit 0
                    ;;
                *)
                    echo "Unknown arg: $1" >> /dev/stderr
                    exit 1
                    ;;
    esac
    shift
done
if [[ $RUN = '0' ]] ; then
    ./setup.sh --run $DRY
    RESULT="$?"
    if [[ $RESULT != '0' ]] ; then
                echo -e "\e${FONTFAIL}Oh no \e${FONTFACE}😭 \e${FONTFAIL}... failed with status $RESULT\e[0m" >> /dev/stderr
                exit $RESULT
    else
                echo -e "\e${FONTOK}Success! \e${FONTFACE}😊 \e[0m"
                exit $RESULT
    fi
fi


echo ''

function info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

function user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

function success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

function fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

function setup_gitconfig () {
  if ! [ -f git/gitconfig.local.symlink ]
  then
    info 'setup gitconfig'

    git_credential='cache'
    if [ "$(uname -s)" == "Darwin" ]
    then
      git_credential='osxkeychain'
    fi

    user ' - What is your github author name?'
    read -e git_authorname
    user ' - What is your github author email?'
    read -e git_authoremail

    sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" git/gitconfig.local.symlink.example > git/gitconfig.local.symlink

    success 'gitconfig'
  fi
}


function link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

function install_dotfiles () {
  info 'installing dotfiles'

  local overwrite_all=false backup_all=false skip_all=false

  for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done

  # install p10k.zsh depending on os  
  if [ "$(uname -s)" == "Darwin" ]
  then
    link_file "$DOTFILES_ROOT/zsh/p10kdesigns/macos.zsh" "$HOME/.p10k.zsh"
  else
    link_file "$DOTFILES_ROOT/zsh/p10kdesigns/ubuntu.zsh" "$HOME/.p10k.zsh"
  fi

  link_file "$DOTFILES_ROOT/zsh/ohmyzsh" "$HOME/.oh-my-zsh"
  link_file "$DOTFILES_ROOT" "$HOME/.dotfiles"
}

function prompt_line() {
    echo -ne "\e${FONTQUESTION}$1 \e${FONTANSWER}"
    read line
    echo -ne "\e[0m"
}

function prompt_line_yn() {
    line=''
    while [[ $line != 'n' ]] && [[ $line != 'y' ]] ; do
                prompt_line "$1 [y/n]"
    done
}

function wait_for_enter() {
    echo
    echo "I'll wait."
    echo -n "Hit [ENTER] when you're done."
    read line
}
 
function install_software() {
  # Install software
  echo "› $DOTFILES/script/install"
  $DOTFILES/script/install.sh
  git submodule init
  git submodule update
}

#------------------------------------------------------------------------------
# Intro
echo
echo -e "  \e${FONTTITLE} Welcome to your tasty $OSTYPE \e[0m"
echo
 
echo 'We are going to run a few clever things to help you get things set up as'
echo 'quickly and painlessly as possible.'
echo
echo -n "Hit [ENTER] when you're ready! "
read line


setup_gitconfig
install_dotfiles

if [[ "$OSTYPE" == "linux-gnu"* ]]; then # Linux

elif [[ "$OSTYPE" == "darwin"* ]]; then #macOS
  info "installing dependencies"
  if source bin/dot | while read -r data; do info "$data"; done
  then
    success "dependencies installed"
  else
    fail "error installing dependencies"
elif [[ "$OSTYPE" == "win32" ]]; then # Wins (what are you doing)

else
 echo "You is using: $OSTYPE and are therefore beyond these dotfiles, good luck on your further adventures"
fi

echo ''
echo '  All installed, you go get out there....'
