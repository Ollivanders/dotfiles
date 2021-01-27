#!/bin/sh
#
# installation of screen

if [[ "$OSTYPE" =~ "linux-gnu"* ]]; then # Linux
    sudo apt-get install screen
elif [[ "$OSTYPE" =~ "darwin"* ]]; then #macOS
    brew "screen"
fi
