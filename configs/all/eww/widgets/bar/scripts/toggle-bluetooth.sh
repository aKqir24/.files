#!/bin/bash
# Toggle bluetooth on/off

STATE=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')
if [ "$STATE" = "yes" ]; then
    bluetoothctl power off
else
    bluetoothctl power on
fi
