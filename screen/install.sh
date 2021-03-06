#!/bin/sh
#
# installation of screen

echo "here"
if [[ "$OSTYPE" =~ "linux-gnu"* ]]; then # Linux
    apt-get install screen
elif [[ "$OSTYPE" =~ "darwin"* ]]; then #macOS
    if [[ ! -d "/Applications/docker.app" ]]; then
        brew install screen
    fi 
fi
