#!/bin/sh
ROFI_DIR="$HOME/.files/configs/rofi"
WIDGET="${1:-launcher}"
THEME_FILE="$ROFI_DIR/styles/${WIDGET}.rasi"

if [ -f "${ROFI_DIR}/scripts/${1}.sh" ]; then
	. "${ROFI_DIR}/scripts/${1}.sh" 
else
	rofi -show "$WIDGET" -config "$ROFI_DIR/config.rasi" -theme "${THEME_FILE}"
fi
