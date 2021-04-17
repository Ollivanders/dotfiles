#!/usr/bin/env bash
#
# general functions for interfaces and printing
set -e

# ANSI fonts
FONTFAIL='[0;1;31m'
FONTOK='[0;1;32m'
FONTFACE='[0;47;40m'
FONTTITLE='[0;35m'
FONTVAR='[36m'
FONTQUESTION='[0;33m'
FONTANSWER='[0m'

DOTFILES_ROOT=$(pwd -P)
PARENT_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_DIRECTORY="$(cd "$(dirname "$PARENT_DIRECTORY")" && pwd -P)"

##------------------------------------------------------------------------------
# Display functions
function begin_step() {
    echo -e "\e${FONTTITLE}"
    echo '----------------------------------------------------------------------'
    echo -e "  Step ${STEP}: $1"
    echo '----------------------------------------------------------------------'
    echo -e '\e[0m'
    STEP=$((STEP + 1))
}

function info() {
    printf "\r  [ \033[00;34m$1\033[0m ] $2\n"
}

function warning() {
    printf "\r  [ \033[00;35m!!\033[0m ] $1\n"
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

function prompt_single_char() {
    echo -ne "\e${FONTQUESTION}$1 \e${FONTANSWER}"
    read -n1 line
    echo -ne "\e[0m"
    echo
}

function prompt_line_yn() {
    line=''
    if [[ ${QUICK} = true ]]; then
        line='y'
    fi
    while [[ $line != 'n' ]] && [[ $line != 'y' ]] && [[ $line != 'e' ]]; do
        prompt_single_char "$1 [y/n/e (e for exit]"
    done
    if [[ $line =~ 'e' ]]; then
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

function sudo() {
    [[ $EUID = 0 ]] || set -- command sudo "$@"
    "$@"
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

    if [[ ${QUICK} = true ]]; then
        overwrite_all=true
    fi
    if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]; then

        if [ $QUICK = false ] && [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]; then

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
