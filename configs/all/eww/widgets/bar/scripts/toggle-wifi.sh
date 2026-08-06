#!/bin/bash
# Toggle wifi on/off via connman

POWERED=$(connmanctl technologies 2>/dev/null | grep -A5 "Type = wifi" | grep "Powered" | awk '{print $NF}')

if [ "$POWERED" = "True" ]; then
    connmanctl disable wifi
else
    connmanctl enable wifi
fi
