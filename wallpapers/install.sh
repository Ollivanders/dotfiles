#!/usr/bin/env bash
#
# configure custom wallpapers

if [[ "$OSTYPE" =~ "linux-gnu"* ]]; then # Linux
    if grep -q Microsoft /proc/version; then
        exit
    else
        exit
    fi
elif [[ "$OSTYPE" =~ "darwin"* ]]; then #macOS
    exit 0
else
    echo "Sorry ${OSTYPE} unsupported"
    exit 0
fi
