#!/usr/bin/env bash
#
# Add custom alerts to sound library
 
if [[ "$OSTYPE" =~ "linux-gnu"* ]]; then # Linux
    if grep -q Microsoft /proc/version; then
        exit
    else
        exit
    fi
elif [[ "$OSTYPE" =~ "darwin"* ]]; then #macOS
    
else
    echo "Sorry ${OSTYPE} unsupported"
    exit 0
fi