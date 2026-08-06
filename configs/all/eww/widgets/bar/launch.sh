#!/bin/sh
if eww active-windows 2>/dev/null | grep -q bar; then
    eww close bar
else
    eww open bar
fi
