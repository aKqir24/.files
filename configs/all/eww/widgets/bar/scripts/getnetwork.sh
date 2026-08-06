#!/bin/bash
# Network status using connman + bluetoothctl + sysfs

WIFI_IF="wlxe0ad47803c43"

wifi_connected() {
    connmanctl technologies 2>/dev/null | awk '/wifi/{p=1} p && /Connected/{gsub(/.*= /,""); print; exit}'
}

eth_connected() {
    for dev in /sys/class/net/eth* /sys/class/net/en* /sys/class/net/end*; do
        if [ -r "$dev/carrier" ] && [ "$(cat "$dev/carrier" 2>/dev/null)" = "1" ]; then
            echo "True"
            return
        fi
    done
    echo "False"
}

tether_connected() {
    for dev in /sys/class/net/usb* /sys/class/net/tether*; do
        if [ -r "$dev/carrier" ] && [ "$(cat "$dev/carrier" 2>/dev/null)" = "1" ]; then
            echo "True"
            return
        fi
    done
    echo "False"
}

case "$1" in
    wifi_status)
        [ "$(wifi_connected)" = "True" ] && echo "connected" || echo "disconnected"
        ;;
    wifi_name)
        [ "$(wifi_connected)" != "True" ] && exit 0
        connmanctl services 2>/dev/null | grep "^\*" | grep "wifi_" | head -1 | sed 's/^\*\s*//;s/\s\+wifi_.*//;s/^[A-Z]\{1,2\} //' | xargs
        ;;
    bluetooth_status)
        bluetoothctl show 2>/dev/null | grep -q "Powered: yes" && echo "powered" || echo "off"
        ;;
    bluetooth_name)
        bluetoothctl devices Connected 2>/dev/null | head -1 | cut -d' ' -f3-
        ;;
    ethernet_status)
        [ "$(eth_connected)" = "True" ] && echo "connected" || echo "disconnected"
        ;;
    ethernet_name)
        [ "$(eth_connected)" != "True" ] && exit 0
        connmanctl services 2>/dev/null | grep "^\*" | grep "ethernet_" | head -1 | sed 's/^\*\s*//;s/\s\+ethernet_.*//' | xargs
        ;;
    ethernet_ip)
        [ "$(eth_connected)" != "True" ] && exit 0
        for iface in eth0 en* end*; do
            ip addr show "$iface" 2>/dev/null | grep -q "inet " && ip -4 addr show "$iface" 2>/dev/null | grep -oP 'inet \K[\d.]+' | head -1 && break
        done
        ;;
    tether_status)
        [ "$(tether_connected)" = "True" ] && echo "connected" || echo "disconnected"
        ;;
    tether_name)
        ip link show 2>/dev/null | grep -oE 'usb[0-9]|tether' | head -1
        ;;
    tether_ip)
        [ "$(tether_connected)" != "True" ] && exit 0
        for iface in usb0 usb1 usb2 tether; do
            ip addr show "$iface" 2>/dev/null | grep -q "inet " && ip -4 addr show "$iface" 2>/dev/null | grep -oP 'inet \K[\d.]+' | head -1 && break
        done
        ;;
    tooltip)
        ETH_IP=$($0 ethernet_ip)
        TETH_IP=$($0 tether_ip)
        if [ "$($0 ethernet_status)" = "connected" ]; then
            echo "LAN: $ETH_IP"
        elif [ "$($0 tether_status)" = "connected" ]; then
            echo "TETHER: $TETH_IP"
        else
            echo "Status: Disconnected"
        fi
        ;;
    tooltip-update)
        TOOLTIP=$($0 tooltip)
        eww update net_tooltip="$TOOLTIP"
        ;;
esac
