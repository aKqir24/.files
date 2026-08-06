#!/bin/sh
if eww active-windows 2>/dev/null | grep -q "powermenu"; then
    eww update pm_profile_open=false
    eww close powermenu
    pkill -f "widgets/powermenu/launch.sh.*monitor" 2>/dev/null
else
    eww update current_profile="$(powerprofilesctl get 2>/dev/null || echo balanced)"
    eww open powermenu
    
    # Background loop to keep profile updated while powermenu is open (monitor tag for pkill)
    (
        # : monitor
        while eww active-windows 2>/dev/null | grep -q "powermenu"; do
            eww update current_profile="$(powerprofilesctl get 2>/dev/null || echo balanced)"
            sleep 1
        done
    ) &
fi
