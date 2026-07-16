#!/bin/bash
QUERY="${1:-}"
DB="$HOME/.config/eww/scripts/all_emojis.txt"
OUT="$HOME/.config/eww/scripts/emoji_items.txt"
[ -f "$DB" ] || exit 1

if [ -z "$QUERY" ]; then
    EMOJIS=$(head -48 "$DB")
else
    EMOJIS=$(awk -F'\t' -v q="$QUERY" '
    BEGIN { n = split(q, words, " ") }
    {
        name = $4
        keywords = $5
        combined = name " " keywords
        ok = 1
        for (i = 1; i <= n; i++) {
            if (words[i] != "" && tolower(combined) !~ tolower(words[i])) { ok = 0; break }
        }
        if (ok) print
    }' "$DB" | head -48)
fi

buf=""
while IFS=$'\t' read -r emoji group subgroup name keywords; do
    [ -z "$emoji" ] && continue
    name_escaped=$(echo "$name" | sed "s/\"/\\\\\"/g")
    buf="${buf} (button :class \"emoji-item\" :onclick \"echo -n '${emoji}' | xclip -selection clipboard\" (label :class \"emoji-char\" :text \"${emoji}\"))"
done <<< "$EMOJIS"

echo "(box :orientation \"v\" :spacing 4 :class \"emoji-grid\" :halign \"fill\" ${buf})" > "$OUT"
