#!/bin/bash
pkill -f sys-stats-monitor.sh 2>/dev/null
~/.files/configs/all/eww/widgets/bar/scripts/sys-stats-monitor.sh &
eww open sys-tooltip
eww update sys_reveal=true
