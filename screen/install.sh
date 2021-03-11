#!/bin/sh
#
# installation of screen

echo "here"
if [[ "$OSTYPE" =~ "linux-gnu"* ]]; then # Linux
    sudo apt-get install screen
elif [[ "$OSTYPE" =~ "darwin"* ]]; then #macOS
    brew install screen
fi
