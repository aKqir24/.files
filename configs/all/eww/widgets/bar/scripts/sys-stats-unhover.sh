#!/bin/bash
pkill -f sys-stats-monitor.sh 2>/dev/null
eww close sys-tooltip 2>/dev/null || true
eww update sys_reveal=false
