#!/usr/bin/env bash
#
# entry point for it all

set -e

if [ -z ${DOTFILES+x} ]; then
  source script/general.sh
else
  source ${DOTFILES}/script/general.sh
fi
cd "$(dirname "$0")"
QUICK=false
DOTFILES_ROOT=$(pwd -P)
PARENT_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_DIRECTORY="$(cd "$(dirname "$PARENT_DIRECTORY")" && pwd -P)"
USING_ZSH=true
RUN='0'
STEP=1

#------------------------------------------------------------------------------
# Intro
function intro() {
  cat docs/logo.txt
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
    echo "Git is not setup yet with these dotfiles"
    echo "because the dotfiles keep gitconfig.local as a seperate file, you need to reconfigure it here"
    prompt_line_yn "Would you like to get it up and running now?"
  else
    echo "Git is already setup"
    prompt_line_yn "Would you like to start a fresh?"
  fi

  if [[ $line =~ 'y' ]]; then
    line='n'
    while [[ ! $line =~ 'y' ]]; do
      echo "Noice, lets do it:"
      info "setup" 'gitconfig'

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
    # git config --global user.name "${user}"
    # git config --global user.email "${email}"
    sed -e "s/AUTHORNAME/$user/g" -e "s/AUTHOREMAIL/$email/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" git/gitconfig.local.example >git/gitconfig.local
    if [[ ! -L $HOME/.gitconfig.local ]]; then
      link_file "git/.gitconfig.local" "$HOME/.gitconfig.local" # do it hear to make sure it defo makes it
    fi
    if [[ ! -L $HOME/.gitconfig ]]; then
      link_file "git/.gitconfig" "$HOME/.gitconfig" # do it hear to make sure it defo makes it
    fi
    success 'gitconfig'
  else
    echo "Sorry didin't mean to invade the setup, lets keep it classy and move on"
  fi
}

#------------------------------------------------------------------------------
# Install dotfiles
function install_dotfiles() {
  local overwrite_all=false backup_all=false skip_all=false

  for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*'); do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done

  if [[ ! -L $HOME/.dotfiles ]]; then
    link_file "$DOTFILES_ROOT" "$HOME/.dotfiles"
  fi
}

function setup_dotfiles() {
  begin_step 'Setting up dotfiles'

  echo "Now we are going to symlink on your config files to this directory"

  prompt_line_yn "Would you like to symlink these files?"

  if [[ $line =~ 'y' ]]; then
    install_dotfiles
  else
    echo "We shall skip over those then..."
  fi
}

#------------------------------------------------------------------------------
# Install software
function install_software() {
  if source $DOTFILES_ROOT/script/softwareInstall.sh | while read -r data; do info "Installing" "$data"; done; then
    success "modules installed"
  else
    fail "error installing modules"
  fi
}

function setup_software() {
  begin_step "Installing all prescribed modules"

  echo "This will run the script at script/softwarenstall.sh, which will recursively run install.sh in all other directories"

  prompt_line_yn "Would you like to do this?"

  if [[ $line =~ 'y' ]]; then
    install_software
  fi
}

#------------------------------------------------------------------------------
# OS individual install
function setup_mac() {
  info "Installing" "default software and iTerm terminal"
  $DOTFILES_ROOT/os/macos/macInstall.sh 2>&1
  info "Configuring" "home brew"
  $DOTFILES_ROOT/homebrew/installBrew.sh 2>&1
}

function setup_ubuntu() {
  if [[ $QUICK = true ]]; then
    $DOTFILES_ROOT/os/ubuntu/ubuntuInstall.sh -q 2>&1
  else
    $DOTFILES_ROOT/os/ubuntu/ubuntuInstall.sh 2>&1
  fi
}

function setup_os() {
  begin_step 'OS specific setup'

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then # Linux
    info "Linux, nice. Setting you up"

    prompt_line_yn "Would you like to proceed with the linux specifc setup?"
    if [[ $line =~ 'y' ]]; then
      info "Update" "before we kick off with the good stuff"
      sudo $DOTFILES_ROOT/os/ubuntu/update.sh 2>&1

      echo " "
      info "zsh>bash" "Would you like to use zsh over bash as your default shell?"
      echo "Reasons to do this are as follows:"
      echo "-ZSH is built off Bash but made better and not in the 80s"
      echo "-its soo much faster, like comparing the Batmobile to a mobility scooter"
      echo "-the plugins, autosuggetion, smart history, syntax highlighting, tasty stuff"
      echo "-these dotfiles are written with ZSH in mind"
      prompt_line_yn "Have you been conviced???"

      if [[ $line =~ 'y' ]]; then
        info "Noice" "lets get zsh setup and installed"
        $DOTFILES_ROOT/zsh/installZSH.sh 2>&1
        info "Note" "logout and back in again for this to work"
      else
        USING_ZSH=false
        info "bash :(" "We shall just stick with bash then"
      fi
      prompt_line_yn "Would you like to proceed with the Ubuntu specifc setup, this includes alerations to your default settings which will not be saved!!!!!!!!!!?"

      if [[ $line =~ 'y' ]]; then
        setup_ubuntu
      fi
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then #macOS
    info "MacOS" "solid, good choice my friend"

    prompt_line_yn "Would you like to proceed with the macOS specifc setup, this includes alerations to your default settings which will not be saved!!!!!!!!!!?"

    if [[ $line =~ 'y' ]]; then
      setup_mac
      info "Setting" "default settings"
      $DOTFILES_ROOT/os/macos/set-defaults.sh 2>&1
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
      if [[ ! -L $HOME/.oh-my-zsh ]]; then
        link_file "$DOTFILES_ROOT/zsh/ohmyzsh" "$HOME/.oh-my-zsh"
      fi

      info "change" "manually after running 'p10k configure' and logging out to init ZSH"
      user "Would you like to use a default .p10k.zsh with a default configuration?"
      user "It is recommended you configure your own, as this will automatically install the appropriate fonts on your behalf if you have not done so"

      action=''
      while [[ $action != 'configure' ]] && [[ $action != 'auto' ]]; do
        prompt_line "[configure/auto]"
        action=$line
      done

      if [[ -f $HOME/.p10k.zsh ]]; then
        rm $HOME/.p10k.zsh
      fi

      if [[ -f $$DOTFILES_ROOT/zsh/p10k.zsh.symlink/.p10k.zsh ]]; then
        rm $DOTFILES_ROOT/zsh/p10k.zsh.symlink/.p10k.zsh
      fi

      if [[ $action = 'configure' ]]; then
        # info "it is recommended that you run: p10k configure"
        # cp "$HOME/.p10k.zsh" "$DOTFILES_ROOT/zsh/p10k.zsh.symlink"
        # rm "$HOME/.p10k.zsh"
        # $DOTFILES_ROOT/zsh/configurep10k.sh
        echo "logout/restart the shell to be on zsh then run 'p10k configure'"
      elif [[ $action = 'auto' ]]; then
        if [ "$(uname -s)" == "Darwin" ]; then
          cp "$DOTFILES_ROOT/zsh/p10kdesigns/macos.zsh" "$DOTFILES_ROOT/zsh/.p10k.zsh.symlink"
        else
          cp "$DOTFILES_ROOT/zsh/p10kdesigns/ubuntu.zsh" "$DOTFILES_ROOT/zsh/.p10k.zsh.symlink"
        fi
      fi
      # link_file "$DOTFILES_ROOT/zsh/p10k.zsh.symlink" "$HOME/.p10k.zsh"
    fi
  fi
}

#------------------------------------------------------------------------------
# Generate SSH key or copy
function setup_ssh_keys() {
  begin_step 'SSH key'
  echo "Let's set up the SSH public and private keys ."
  prompt_line_yn "Would you like to do this?"

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
      # echo -n "${copycommand}" | xsel --clipboard
      echo "Run this in bash/cygwin on your host system, \e${FONTFACE}😎 \e[0m:"
      echo
      echo -e "  \e${FONTVAR}${copycommand}\e[0m "
      wait_for_enter

    elif [[ $action = 'generate' ]]; then # Generate new key
      ssh-keygen
      # ssh-add "${pub_key}"
      # ssh-add -l
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

    info "Note" "You can copy this ssh key to your clipboard with the 'pubkey' function, located in bin/"
  fi
}

#------------------------------------------------------------------------------
# Setup complete print out
function setup_complete() {
  success "Everything has been installed, polished and setup,"
  # warning "If this is new setup of ZSH, you may have to reset the shell or "
  info "Reload Shell" "for changes to take effect"

  printf "Run 'reload!' to do this if previously setup, otherwise to re-source your rc file run:\n"
  printf "source script/re-source.sh \n"
  printf "If this the first time configuring zsh, please logout \n"
  printf "\n"
  # printf "If you followed the instructions correctly, did not change anything groundbreaking and avoided errors\n"
  printf "You should now be living in paradise: \n"
  printf "Upon seeing your setup, girls will be throwing themsevles at you, 
Danny Devito will probs be in your DMs and you will becoming instantly aroused every time you open a command line.
But now your interface looks like its been crafted by Tony Stark himself, go back out there and actually do some work.\n"
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
  begin_step "Update Software and Dotfiles Configuration"

  info "Update" "dotfiles repo from remote version"
  cd ${DOTFILES_ROOT}
  git config pull.rebase false
  git pull

  install_dotfiles
  install_software

  # setup_os
  if [[ "$OSTYPE" =~ "linux-gnu"* ]]; then # Linux
    setup_ubuntu
  elif [[ "$OSTYPE" =~ "darwin"* ]]; then #macOS
    setup_mac
  else
    echo "Sorry ${OSTYPE} unsupported"
    exit 0
  fi

  info "All updated" "now crack on with it"
  exit
}

#---------------------------------------------------------------------------------------------------------------------
# Run functions

function displayUsageAndExit() {
  echo "letsgo -- entry point for dotfile management"
  echo "  for all your dotfiling needs"
  echo ""
  echo "Usage: <dot,letsgo.sh> [options] (dot is a global function after inital setup)"
  echo ""
  echo "Options:"
  # echo "  -c, --config          Using a config file for setup is an incoming feature"
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
    prompt_single_char " which would you like to setup"

    case $line in
    "e")
      exit
      ;;
    "1")
      update_software
      ;;
    "2")
      setup_git
      ;;
    "3")
      setup_dotfiles
      ;;
    "4")
      setup_os
      ;;
    "5")
      setup_software
      ;;
    "6")
      setup_zsh
      ;;
    "7")
      setup_ssh_keys
      ;;
    "8")
      setup_default_editor
      ;;
    *)
      echo "Please pick for the the possible setup configurations: "
      choose
      ;;
    esac
  }

  while [[ $line != 'exit' ]]; do
    echo " e - exit "
    echo " 1 - projects dir "
    echo " 2 - update "
    echo " 3 - git "
    echo " 4 - dotfiles "
    echo " 5 - os "
    echo " 6 - software "
    echo " 7 - zsh "
    echo " 8 - ssh_keys "
    echo " 9 - default_editor "

    choose

    prompt_line_yn "Would you like to run another setup"
    if [[ $line =~ 'n' ]]; then
      exit
    fi
  done
}

function quick_install() {
  QUICK=true
  install_dotfiles
  install_software

  # setup_os
  if [[ "$OSTYPE" =~ "linux-gnu"* ]]; then # Linux
    setup_ubuntu
  elif [[ "$OSTYPE" =~ "darwin"* ]]; then #macOS
    setup_mac
  else
    echo "Sorry ${OSTYPE} unsupported"
    exit 0
  fi
  exit
}

#------------------------------------------------------------------------------
# Parse args
trap clean_up EXIT
while [[ $# -gt 0 ]]; do
  case "$1" in
  "-e" | "--edit")
    letsgo_file="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
    if [[ $EDITOR = "" ]]; then
      exec "$EDITOR" "$letsgo_file"
    else
      exec "code" "$letsgo_file"
    fi
    exit
    ;;
  "-i" | "--interactive")
    specific_choice
    ;;
  "-h" | "--help")
    displayUsageAndExit
    ;;
  "-u" | "--update")
    update_configuration
    ;;
  "-q" | "--quick")
    quick_install
    ;;
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
