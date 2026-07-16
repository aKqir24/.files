#!/bin/bash
# Generates yuck code for app list from cache, writes to search_items.txt
# Usage: search-apps.sh [query]
QUERY="${1:-}"
CACHE="$HOME/.cache/eww/apps.cache"
OUT="$HOME/.config/eww/scripts/search_items.txt"
[ -f "$CACHE" ] || ~/.config/eww/scripts/cache-apps

if [ -z "$QUERY" ]; then
    APPS=$(head -12 "$CACHE")
else
    APPS=$(awk -F'\t' -v q="$QUERY" '
    BEGIN { n = split(q, words, " ") }
    {
        name = $2
        ok = 1
        for (i = 1; i <= n; i++) {
            if (words[i] != "" && tolower(name) !~ tolower(words[i])) { ok = 0; break }
        }
        if (ok) print
    }' "$CACHE" | head -12)
fi

buf=""
while IFS=$'\t' read -r exec_line name icon_path; do
    [ -z "$exec_line" ] && continue
    exec_escaped=$(echo "$exec_line" | sed "s/\"/\\\\\"/g")
    if [ -n "$icon_path" ] && [ -f "$icon_path" ]; then
        icon_part="(image :path \"${icon_path}\" :image-width 32 :image-height 32)"
    else
        initial=$(echo "$name" | cut -c1 | tr '[:lower:]' '[:upper:]')
        icon_part="(label :class \"app-letter\" :halign \"center\" :valign \"center\" :text \"${initial}\")"
    fi
    buf="${buf} (button :class \"app-item\" :onclick \"${exec_escaped} &\" (box :orientation \"h\" :spacing 12 :valign \"center\" ${icon_part} (label :class \"app-name\" :halign \"start\" :text \"${name}\")))"
done <<< "$APPS"

echo "(box :orientation \"v\" :spacing 4 :class \"app-list\" :halign \"fill\" ${buf})" > "$OUT"
