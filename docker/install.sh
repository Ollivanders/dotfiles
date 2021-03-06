#!/usr/bin/env bash
#
# Install docker script 

if [[ "$OSTYPE" =~ "linux-gnu"* ]]; then # Linux
    if grep -q Microsoft /proc/version; then
      echo "Sorry bro, install docker on your own"
      exit
    else
        curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
        sh /tmp/get-docker.sh
    fi
elif [[ "$OSTYPE" =~ "darwin"* ]]; then #macOS
    if [[ ! -d "/Applications/docker.app" ]]; then
        brew install --cask docker
    fi 
else
    echo "Sorry ${OSTYPE} unsupported"
    exit 0
fi