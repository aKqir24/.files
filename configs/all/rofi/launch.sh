#!/bin/sh
ROFI_DIR="$HOME/.files/configs/all/rofi"
WIDGET="${1:-launcher}"
rofi -show "$WIDGET" -config "$ROFI_DIR/config.rasi" -theme "$ROFI_DIR/styles/${WIDGET}.rasi"
