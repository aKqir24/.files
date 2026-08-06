#!/bin/bash
while true; do
    cpu=$(top -bn1 | grep 'Cpu(s)' | awk '{printf "%.1f", $2+$4}' 2>/dev/null || echo "0")
    ram=$(free | awk '/Mem:/{printf "%.1f", $3/$2*100}' 2>/dev/null || echo "0")
    storage=$(df / | awk 'NR==2{gsub(/%/,"",$5); print $5}' 2>/dev/null || echo "0")
    temp=$(awk '{t=$1/1000; printf (t == int(t) ? "%d" : "%.1f"), t}' /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo "0")
    
    eww update cpu_detail="$cpu" ram_detail="$ram" storage_detail="$storage" temp_detail="$temp" 2>/dev/null
    sleep 0.5
done
