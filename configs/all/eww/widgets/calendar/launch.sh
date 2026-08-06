#!/bin/sh
if eww active-windows 2>/dev/null | grep -q calendar; then
    eww close calendar
else
    eww update cal_day=$(date +%-d) cal_month_num=$(date +%-m) cal_year=$(date +%Y)
    eww open calendar
fi
