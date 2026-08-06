#!/bin/bash
# WiFi status and info for eww tooltip

wifi_powered() {
    connmanctl technologies 2>/dev/null | awk '/wifi/{p=1} p && /Powered/{gsub(/.*= /,""); print; exit}'
}

wifi_connected() {
    connmanctl technologies 2>/dev/null | awk '/wifi/{p=1} p && /Connected/{gsub(/.*= /,""); print; exit}'
}

case "$1" in
    status)
        if [ "$(wifi_powered)" != "True" ]; then
            echo "disabled"
        elif [ "$(wifi_connected)" = "True" ]; then
            echo "connected"
        else
            echo "disconnected"
        fi
        ;;
    tooltip)
        if [ "$(wifi_powered)" != "True" ]; then
            echo "Wifi: Disabled"
        elif [ "$(wifi_connected)" = "True" ]; then
            SSID=$(connmanctl services 2>/dev/null | grep "^\*" | grep "wifi_" | head -1 | sed 's/^\*\s*//;s/\s\+wifi_.*//;s/^[A-Z]\{1,2\} //' | xargs)
            echo "Status: Connected
Network: $SSID"
        else
            echo "Status: Disconnected"
        fi
        ;;
    name)
        [ "$(wifi_connected)" != "True" ] && exit 0
        connmanctl services 2>/dev/null | grep "^\*" | grep "wifi_" | head -1 | sed 's/^\*\s*//;s/\s\+wifi_.*//;s/^[A-Z]\{1,2\} //' | xargs
        ;;
    tooltip-update)
        TOOLTIP=$($0 tooltip)
        eww update net_tooltip="$TOOLTIP"
        ;;
esac
