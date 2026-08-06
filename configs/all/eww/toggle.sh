#!/bin/bash
# Usage: sh toggle.sh [widget name]

EWW=$(which eww)
CFG="$HOME/.files/configs/all/eww"

# Set to true to close all other open widgets (except bar) when opening a new one
CLOSE_OTHERS=true

## Run eww daemon if not running already
if [[ ! $(pidof eww) ]]; then
	${EWW} --config "$CFG" daemon
	sleep 1
fi

WIDGET="$1"

# Check if the requested widget is already active
IS_ACTIVE=false
if ${EWW} --config "$CFG" active-windows 2>/dev/null | grep -q "${WIDGET}"; then
    IS_ACTIVE=true
fi

if [ "$CLOSE_OTHERS" = true ]; then
    # Close all active windows except 'bar'
    for win in $(${EWW} --config "$CFG" active-windows 2>/dev/null); do
        if [ "$win" != "bar" ]; then
            ${EWW} --config "$CFG" close "$win"
        fi
    done
    
    # If it wasn't active, open it. If it was active, closing everything left it closed (toggled off).
    if [ "$IS_ACTIVE" = false ]; then
        ${EWW} --config "$CFG" open "$WIDGET"
    fi
else
    # Fallback to individual widget launch script if CLOSE_OTHERS is false
    sh "$CFG/widgets/${WIDGET}/launch.sh"
fi
