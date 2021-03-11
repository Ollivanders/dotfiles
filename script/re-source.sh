CURRENT_SHELL=$(basename $(echo ${SHELL}))

if [[ $CURRENT_SHELL =~ "zsh" ]]; then
    source ~/.zshrc
else
    source ~/.bashrc
fi
