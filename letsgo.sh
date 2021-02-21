#!/usr/bin/env bash
#
# entry point for it all

set -e

# ANSI fonts
FONTFAIL='[0;1;31m'
FONTOK='[0;1;32m'
FONTFACE='[0;47;40m'
FONTTITLE='[0;35m'
FONTVAR='[36m'
FONTQUESTION='[0;33m'
FONTANSWER='[0m'

cd "$(dirname "$0")"

DOTFILES_ROOT=$(pwd -P)
PARENT_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_DIRECTORY="$(cd "$(dirname "$PARENT_DIRECTORY")" && pwd -P)"

USING_ZSH=true
RUN='0'

STEP=1
#------------------------------------------------------------------------------
# Display functions
function begin_step() {
  echo -e "\e${FONTTITLE}"
  echo '----------------------------------------------------------------------'
  echo -e "  Step ${STEP}: $1\e[0m"
  STEP=$((STEP + 1))
}

function info() {
  printf "\r  [ \033[00;34m...\033[0m ] $1\n"
}

function warning() {
  printf "\r  [ \033[00;36m\!\!\033[0m ] $1\n"
}

function user() {
  printf "\r  [ \033[0;33m???\033[0m ] $1\n"
}

function success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

function fail() {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

#------------------------------------------------------------------------------
# Prompting functions

function prompt_line() {
  echo -ne "\e${FONTQUESTION}$1 \e${FONTANSWER}"
  read line
  echo -ne "\e[0m"
}

function prompt_line_yn() {
  line=''
  while [[ $line != 'n' ]] && [[ $line != 'y' ]] && [[ $line != 'exit' ]]; do
    prompt_line "$1 [y/n/exit]"
  done
  if [[ $line =~ 'exit' ]]; then
    echo "Exiting the letsgo protocol..."
    exit 0
  fi
}

function wait_for_enter() {
  echo
  echo "I'll wait."
  echo -n "Hit [ENTER] when you're done."
  read line
}

#------------------------------------------------------------------------------
# Error control and Clean Up
# Used for error handling, so script calls its self if its planning to run anything
function clean_up() {
  RESULT="$?"

  if [[ $RESULT != '0' ]]; then
    echo -e "\e${FONTFAIL}Oh no \e${FONTFACE}😭 \e${FONTFAIL}, failed with status $RESULT\e[0m" >>/dev/stderr
    exit $RESULT
  else
    echo -e "\e${FONTOK}Setup Successful \e${FONTFACE}😊\e[0m"
    exit $RESULT
  fi
}

function link_file() {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]; then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]; then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]; then

        skip=true

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
        o)
          overwrite=true
          ;;
        O)
          overwrite_all=true
          ;;
        b)
          backup=true
          ;;
        B)
          backup_all=true
          ;;
        s)
          skip=true
          ;;
        S)
          skip_all=true
          ;;
        *) ;;

        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]; then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]; then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]; then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]; then # "false" or empty
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

#------------------------------------------------------------------------------
# Intro
function intro() {
  echo
  echo -e "  \e${FONTTITLE} Welcome to your tasty $OSTYPE setup \e[0m"
  echo

  echo 'You will recieve a prompt at most decisions.'
  echo 'This is only to give you more control over the install process if there are custom parts of your system,'
  echo 'Therefore do not shy away from just always saying yes ;)'
  echo 'From here you should be able to get this system quickly grooving...'
  echo
  echo 'Warning, we are proceeding with the fundamental alteraion of some of your system default settings.'
  echo 'This will probably not break anything but will alter settings which are not recoverable'
  wait_for_enter
}

#------------------------------------------------------------------------------
# Git Config
function setup_git() {
  begin_step "GitConfig"
  echo -e "Lets configure git first" #\e${FONTFACE}😊\e[0m

  if ! [ -f git/gitconfig.local.symlink ]; then
    echo "Git is not setup yet"
    prompt_line_yn "Would you like to get it up and running now?"
  else
    echo "Git is already setup"
    prompt_line_yn "Would you like to start a fresh?"
  fi

  if [[ $line =~ 'y' ]]; then
    line='n'
    while [[ ! $line =~ 'y' ]]; do
      echo "Noice, lets do it:"
      info 'setup gitconfig'

      git_credential='cache'
      if [[ "$OSTYPE" == "darwin"* ]]; then #macOS
        git_credential='osxkeychain'
      fi

      echo "We're going to configure git's global settings."
      prompt_line "What's your git author name?"
      user=$line
      prompt_line "What's your email?"
      email=$line
      echo "I'm going to run this:"
      echo
      echo -e "  git config --global user.name '\e${FONTVAR}${user}\e[0m'"
      echo -e "  git config --global user.email '\e${FONTVAR}${email}\e[0m'"
      echo

      prompt_line_yn "This good???"
    done
    #  git config --global user.name "${user}"
    #  git config --global user.email "${email}"
    sed -e "s/AUTHORNAME/$user/g" -e "s/AUTHOREMAIL/$email/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" git/gitconfig.local.symlink.example >git/gitconfig.local.symlink
    success 'gitconfig'
  else
    echo "Sorry didin't mean to invade the setup, lets keep it classy and move on"
  fi
}

#------------------------------------------------------------------------------
# Install dotfiles
function setup_dotfiles() {
  begin_step 'Setting up dotfiles'

  echo "Now we are going to symlink on your config files to this directory"

  function install_dotfiles() {
    local overwrite_all=false backup_all=false skip_all=false

    for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*'); do
      dst="$HOME/.$(basename "${src%.*}")"
      link_file "$src" "$dst"
    done

    if [[ ! -d $HOME/.dotfiles ]]; then
      link_file "$DOTFILES_ROOT" "$HOME/.dotfiles"
    fi
  }

  prompt_line_yn "Would you like to symlink these files?"

  if [[ $line =~ 'y' ]]; then
    install_dotfiles
  else
    echo "We shall skip over those then..."
  fi

  echo "If you setup a projects directory, you can c [tab] into it from anywhere "
  prompt_line_yn "Would you like to setup a projects directory?"
  if [[ $line =~ 'y' ]]; then
      projects_dir="${HOME}/Documents/Projects"
      prompt_line_yn "Is ${projects_dir} okay as the project path?"
      if [[ $line =~ 'y' ]]; then
        done=true
      else  
        done=false
        while [ $done = false ]; do
            line="_[]"
            while [[ ! -d $line ]]; do
              prompt_line_yn "Please specific Project Dir as a evaluative path"
              projects_dir=$line
            done
            prompt_line_yn "Is ${projects_dir} okay as the project path?"
            if [[ $line =~ 'y' ]]; then
              done=true
            fi
        done
      fi
    echo "" > "export PROJECTS_DIR={projects_dir}"
  fi
}

#------------------------------------------------------------------------------
# Install software
function setup_software() {
  begin_step "Installing all prescribed modules"

  echo "This will run the script at script/install.sh, which will recursively run install.sh in all other directories"

  prompt_line_yn "Would you like to do this?"

  if [[ $line =~ 'y' ]]; then
    if source $DOTFILES_ROOT/script/install.sh | while read -r data; do info "$data"; done; then
      success "modules installed"
    else
      fail "error installing modules"
    fi
  fi
}

#------------------------------------------------------------------------------
# OS individual install
function setup_os() {
  begin_step 'OS specific setup'

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then # Linux
    info "Linux, nice. Setting you up"

    prompt_line_yn "Would you like to proceed with the linux specifc setup?"
    if [[ $line =~ 'y' ]]; then
      info "Running a routine software update before we kick off with the good stuff"
      sudo $DOTFILES_ROOT/os/ubuntu/update.sh 2>&1

      echo " "
      info "Would you like to use zsh over bash as your default shell?"
      echo "Reasons to do this are as follows:"
      echo "-ZSH is built off Bash but made better and not in the 80s"
      echo "-its soo much faster, like comparing the Batmobile to a mobility scooter"
      echo "-the plugins, autosuggetion, smart history, syntax highlighting, tasty stuff"
      echo "-these dotfiles are written with ZSH in mind"
      prompt_line_yn "Have you been conviced???"

      if [[ $line =~ 'y' ]]; then
        info "Noice, lets get zsh setup and installed"
        $DOTFILES_ROOT/zsh/installZSH.sh 2>&1
        info "Please remeber to logout and back in again for this to work"
      else
        USING_ZSH=false
        info "We shall just stick with bash then"
      fi
      sudo $DOTFILES_ROOT/os/ubuntu/ubuntuInstall.sh 2>&1
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then #macOS
    info "MacOS, solid, good choice my friend"

    prompt_line_yn "Would you like to proceed with the macOS specifc setup, this includes alerations to your default settings which will not be saved!!!!!!!!!!?"

    if [[ $line =~ 'y' ]]; then
      info "Setting default settings"
      $DOTFILES_ROOT/os/macos/set-defaults.sh 2>&1
      info "Installing default software and iTerm terminal"
      $DOTFILES_ROOT/os/macos/macInstall.sh 2>&1
      info "Configuring home brew"
      $DOTFILES_ROOT/homebrew/installBrew.sh 2>&1
    fi

  elif [[ "$OSTYPE" == "win"* ]]; then # Wins (what are you doing)
    echo "Why windows man, why????"
    echo "I got nothing for you. You are currently not supported."
    echo "But would recommend installing WSL and then getting this bad boi re-setup"
  else
    echo "You is using: $OSTYPE and are therefore beyond these dotfiles, good luck on your further adventures"
  fi
}

#------------------------------------------------------------------------------
# Setting up ZSH
function setup_zsh() {
  if [ "${USING_ZSH}" == true ]; then
    prompt_line_yn "We are going to install ohmyzsh, some additional plugins then configure p10k, you okay with this?"
    if [[ $line =~ 'y' ]]; then
      begin_step 'ZSH and shell configuration'

      #------------------------------------------------------------------------------
      # Init zsh themes and external libraries
      echo "Hang tight while we install some external libraries"
      git submodule init
      git submodule update
      [[ ! -d $HOME/.oh-my-zsh ]] || link_file "$DOTFILES_ROOT/zsh/ohmyzsh" "$HOME/.oh-my-zsh"

      info "You can change this manually after running 'p10k configure'"
      user "Would you like to use a default .p10k.zsh with a default configuration?"
      user "It is recommended you configure your own, as this will automatically install the appropriate fonts on your behalf if you have not done so"

      action=''
      while [[ $action != 'configure' ]] && [[ $action != 'auto' ]]; do
        prompt_line "[configure/auto]"
        action=$line
      done

      [[ -f $HOME/.p10k.zsh ]] || rm $HOME/.p10k.zsh
      [[ -f $$DOTFILES_ROOT/zsh/p10k.zsh.symlink/.p10k.zsh ]] || rm $DOTFILES_ROOT/zsh/p10k.zsh.symlink/.p10k.zsh

      if [[ $action = 'configure' ]]; then
        # info "it is recommended that you run: p10k configure"
        # cp "$HOME/.p10k.zsh" "$DOTFILES_ROOT/zsh/p10k.zsh.symlink"
        # rm "$HOME/.p10k.zsh"
        $DOTFILES_ROOT/zsh/configurep10k.sh
      elif [[ $action = 'auto' ]]; then
        if [ "$(uname -s)" == "Darwin" ]; then
          cp "$DOTFILES_ROOT/zsh/p10kdesigns/macos.zsh" "$DOTFILES_ROOT/zsh/.p10k.zsh.symlink"
        else
          cp "$DOTFILES_ROOT/zsh/p10kdesigns/ubuntu.zsh" "$DOTFILES_ROOT/zsh/.p10k.zsh.symlink"
        fi
      fi
      link_file "$DOTFILES_ROOT/zsh/p10k.zsh.symlink" "$HOME/.p10k.zsh"
    fi
  fi
}

#------------------------------------------------------------------------------
# Generate SSH key or copy
function setup_ssh_keys() {
  begin_step 'SSH key'
  echo "Let's set up the SSH public and private keys ."
  echo

  if [[ $line =~ 'y' ]]; then
    echo "I can generate new keys, or you can copy existing keys from the"
    echo "host system."
    action=''
    while [[ $action != 'generate' ]] && [[ $action != 'copy' ]]; do
      prompt_line "What do you want to do? [generate/copy]"
      action=$line
    done

    pub_key="${HOME}/.ssh/id_rsa.pub"

    if [[ $action = 'copy' ]]; then # Copy existing key
      copycommand="scp -r /path/to/host/.ssh $(whoami)@$(hostname -I | awk '{print $2}'):$(
        cd
        pwd
      )/.ssh"
      echo -n "${copycommand}" | xsel --clipboard
      echo "Run this in bash/cygwin on your host system, I've already copied"
      echo -e "it into the clipboard for you \e${FONTFACE}😎 \e[0m:"
      echo
      echo -e "  \e${FONTVAR}${copycommand}\e[0m "
      wait_for_enter

    elif [[ $action = 'generate' ]]; then # Generate new key
      ssh-keygen
      ssh-add "${pub_key}"
      ssh-add -l
    fi

    # Validate
    if [ ! -e "${pub_key}" ]; then
      echo -e "\e${FONTFAIL}There's no ${pub_key}... Aborting\e[0m "
      exit 1
    fi

    EXPORT_TO_BASHRC="${EXPORT_TO_BASHRC}\nexport GIT_SSH_COMMAND='ssh -o ControlPath=none'"
    bashrc="${HOME}/.bashrc"
    echo -e "Writing to \e${FONTVAR}${bashrc}\e[0m"
    echo -e "# Generated by setup.sh - $(date)\n${EXPORT_TO_BASHRC}" >>"${bashrc}"
    . "${bashrc}"

    sshconfig="${HOME}/.ssh/config"
    if [[ ! -e "${sshconfig}" ]]; then
      echo -e "Writing to \e${FONTVAR}${sshconfig}\e[0m"
      echo -e "Host bitbucket.org\n ControlMaster yes\n IdentityFile ~/.ssh/id_rsa" >"${sshconfig}"
    fi

    info "You can copy this ssh key to your clipboard with the 'pubkey' function, located in bin/"
  fi
}

#------------------------------------------------------------------------------
# Setup complete print out
function setup_complete() {
  echo ""
  success "Everything has been installed, polished and setup,"
  echo ""
  echo "If you followed the instructions correctly, did not change anything groundbreaking and avoided errors"
  echo "You should now be living in paradise:"
  echo "Upon seeing your setup, girls will be throwing themsevles at you,"
  echo "Danny Devito will probs be in your DMs and you will becoming instantly aroused every time you open a command line."
  echo "But now your interface looks like its been crafted by Tony Stark himself, go back out there and actually do some work."
}

#------------------------------------------------------------------------------
# currently handled in other file
# Setup default editor
function setup_default_editor() {
  begin_step 'default editor'

  if [ "${EDITOR}" != "" ]; then
    echo "Your current editor is: ${EDITOR}"
    prompt_line_yn "Would you like to reconfigure this?"
  else
    prompt_line_yn "Would you like to set your default editor?"
  fi

  if [[ $line =~ 'y' ]]; then
    editor=''
    while [[ $editor = '' ]]; do
      echo "Let's set up the editor that git will use."
      echo 'Type "emacs", "code" "vim", "nano" or some other booky editor if you got it. You can also input a custom value or'
      echo "leave blank to use default."
      prompt_line "What editor do you want?"
      editor=$line

      if [[ $editor =~ '' ]]; then
        editor='-'
        echo "Ok, I won't touch GIT_EDITOR."
      else
        echo "I'm going put this is ~/.bashrc:"
        echo
        echo -e "  export GIT_EDITOR='\e${FONTVAR}${editor}\e[0m'" # TODO: be more descriptive
        echo -e "  export EDITOR='\e${FONTVAR}${editor}\e[0m'"     # TODO: be more descriptive
        echo
        prompt_line_yn "Is this what you want?"
        if [[ $line =~ 'y' ]]; then
          if [ -f "~/.bashrc" ]; then
            echo "export EDITOR=${editor}" >>'~/.bashrc'
            echo "export GIT_EDITOR=${editor}" >>'~/.bashrc'
          fi
          if [ -f "~/.zshrc" ]; then
            echo "export EDITOR=${editor}" >>'~/.zshrc'
            echo "export GIT_EDITOR=${editor}" >>'~/.zshrc'
          fi
          # EXPORT_TO_BASHRC="${EXPORT_TO_BASHRC}\nexport GIT_EDITOR='${editor}'"
        else
          editor=''
        fi
      fi
    done
  fi
}

function update_configuration() {
  begin_step "Update Software and Dotfiles Configuration "

  warning "Sorry, updating of exsisting setup still needs to be coded up"
}

#---------------------------------------------------------------------------------------------------------------------
# Run functions

function displayUsageAndExit() {
  echo "letsgo -- entry point for dotfile management"
  echo "  for all your dotfiling needs"
  echo ""
  echo "Usage: dot/letsgo.sh [options] (dot is a global function after inital setup)" 
  echo ""
  echo "Options:"
  echo "  -c, --config          Using a config file for setup is an incoming feature"
  echo "  -e, --edit            Open dotfiles directory for editing"
  echo "  -h, --help            Show this help message and exit"
  echo "  -i, --interactive     Choose specific setups to run"
  echo "  -u, --update          Update previously installed configuration"
  exit
}

function specific_choice() {
  begin_step "Choose a setup to run"
  echo "Avalaible setup configurations: "

  function choose() {
    prompt_line " which would you like to setup"

    case $line in
    "1")
      exit
      ;;
    "2")
      update_software
      ;;
    "3")
      setup_git
      ;;
    "4")
      setup_dotfiles
      ;;
    "5")
      setup_os
      ;;
    "6")
      setup_software
      ;;
    "7")
      setup_zsh
      ;;
    "8")
      setup_ssh_keys
      ;;
    "9")
      setup_default_editor
      ;;
    *)
      echo "Please pick for the the possible setup configurations: "
      choose
      ;;
    esac
  }

  while [[ $line != 'exit' ]]; do
    echo " 1 - exit "
    echo " 2 - update "
    echo " 3 - git "
    echo " 4 - dotfiles "
    echo " 5 - os "
    echo " 6 - software "
    echo " 7 - zsh "
    echo " 8 - ssh_ke565s "
    echo " 9 - default_editor "

    choose

    prompt_line_yn "Would you like to run another setup"
    if [[ $line =~ 'n' ]]; then
      exit
    fi
  done
}

function config_file() {
  warning "using a config file for setup is an incoming feature"
  echo "For now, just love the command line and everything it gives you"
  exit
}

#------------------------------------------------------------------------------
# Parse args
trap clean_up EXIT
while [[ $# -gt 0 ]]; do
  case "$1" in
  "-c" | "--config")
    config_file
    ;;
  "-e" | "--edit")
    exec "$EDITOR" "$dotfilesDirectory"
    exit
    ;;
  "-i" | "--interactive")
    specific_choice
    ;;
  "-h" | "--help")
    displayUsageAndExit
    ;;
  "-u" | "--update") ;;

  *)
    echo "Unknown arg: $1" >>/dev/stderr
    displayUsageAndExit
    ;;
  esac
  shift
done

echo ''

intro
setup_git
setup_dotfiles
setup_os
setup_software
setup_zsh
setup_ssh_keys
# setup_default_editor
setup_complete
