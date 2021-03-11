#!/usr/bin/env bash
#
# A sample function with chmod 777 permissions, dividing each OS
# Copy file and rewrite with your own fabulous needs

if [[ "$OSTYPE" =~ "linux-gnu"* ]]; then # Linux
    sudo apt-get install vim
elif [[ "$OSTYPE" =~ "darwin"* ]]; then # macOS
    brew install vim
else
    echo "Sorry ${OSTYPE} unsupported"
    exit 0
fi
