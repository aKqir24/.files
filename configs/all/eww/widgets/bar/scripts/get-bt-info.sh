#!/bin/bash
# Get bluetooth status, icon, and formatted name

POWERED=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')
if [ "$POWERED" != "yes" ]; then
    STATUS="Status: Disabled"
    ICON="󰂯"
    NAME="None"
elif [ -z "$(bluetoothctl devices Connected 2>/dev/null | head -1 | awk '{print $2}')" ]; then
    STATUS="Status: Enabled"
    ICON="󰂯"
    NAME="None"
else
    STATUS="Status: Connected"
    DEVICE=$(bluetoothctl devices Connected 2>/dev/null | head -1 | awk '{print $2}')
    NAME=$(bluetoothctl devices Connected 2>/dev/null | head -1 | cut -d' ' -f3-)
    CLASS=$(bluetoothctl info "$DEVICE" 2>/dev/null | grep "Icon:" | awk '{print $2}')
    case "$CLASS" in
        audio-card|audio-device|audio-woofer|audio-input-microphone|audio-headphones|audio-headset)
            ICON="󰂰"
            ;;
        phone|handset|portable-player)
            ICON="󰂴"
            ;;
        *)
            ICON="󰂱"
            ;;
    esac
fi

case "${1}" in 
    "STATUS") echo "$STATUS" ;;
    "ICON") echo "$ICON" ;;
    "DEVICE") echo "Device: $NAME" ;;
    "tooltip-update")
        if [ "$NAME" = "None" ]; then
            TOOLTIP="$STATUS"
        else
            TOOLTIP="$STATUS
Device: $NAME ($CLASS)"
        fi
        eww update net_tooltip="$TOOLTIP"
        ;;
    *) 
        if [ "$NAME" = "None" ]; then
            echo "$STATUS"
        else
            echo "$STATUS
Device: $NAME"
        fi
        ;;
esac
