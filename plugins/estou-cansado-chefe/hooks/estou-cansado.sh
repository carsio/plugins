#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$DIR/.." && pwd)"
if [[ -n "${WINDIR:-}" || "$(uname -s 2>/dev/null || true)" == MINGW* || "$(uname -s 2>/dev/null || true)" == CYGWIN* || "$(uname -s 2>/dev/null || true)" == MSYS* ]]; then
  if command -v powershell.exe >/dev/null 2>&1; then
    exec powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$DIR/estou-cansado.ps1"
  fi
fi

RAW="$(cat || true)"
FALAS_FILE="$DIR/falas.txt"
PLAY="$ROOT/skills/estou-cansado-chefe/scripts/play.sh"
AUDIO="$ROOT/skills/estou-cansado-chefe/assets/eu-estou-cansado-chefe.mp3"
STAMP="${TMPDIR:-/tmp}/estou-cansado-chefe.last"
HEAVY_REMAINING=40
NEAR_END_REMAINING=20
CONTEXT_PERCENT=80
COOLDOWN=720

if [[ -f "$FALAS_FILE" ]]; then
  mapfile -t FALAS < <(grep -v '^[[:space:]]*$' "$FALAS_FILE")
else
  FALAS=("Estou cansado, chefe.")
fi

exhausted() {
  printf '%s' "$1" | grep -Eiq 'status["[:space:]:]*429|\b429\b|out of (usage|quota|credits)|quota[_ -]?(exceeded|exhausted)|limit[_ -]?(reached|exceeded|exhausted)|resource[_ -]?exhausted|remaining[_]?([Pp]ercent)["[:space:]:]*0\b|sem (cota|crédito|credito)|limite (atingido|esgotado)|usage[_ ]percent["[:space:]:]*100|no remaining|(rate[_ -]?limit|usage[_ -]?limit)[_ -]?(exceeded|reached)'
}

remaining_from_text() {
  printf '%s' "$1" | grep -Eoi 'remaining[_]?percent["[:space:]:]*[0-9]+([.][0-9]+)?' | grep -Eo '[0-9]+([.][0-9]+)?$' || true
}

context_from_text() {
  printf '%s' "$1" | grep -Eiq 'precompact|pre[_-]?compact|context (window )?(almost |nearly )?(full|limit)|compaction' && return 0
  local pct
  pct="$(printf '%s' "$1" | grep -Eoi '(context|window|token)[^0-9]{0,40}(percent|used|usage)[^0-9]{0,10}[0-9]+([.][0-9]+)?' | grep -Eo '[0-9]+([.][0-9]+)?$' | tail -n 1 || true)"
  [[ -n "$pct" ]] && awk -v n="$pct" -v lim="$CONTEXT_PERCENT" 'BEGIN { exit !(n+0 >= lim) }'
}

EVENT="$(printf '%s' "$RAW" | tr '\n' ' ')"
if exhausted "$RAW"; then
  exit 0
fi

REMAININGS=()
while IFS= read -r n; do
  [[ -n "$n" ]] && REMAININGS+=("$n")
done < <(remaining_from_text "$RAW")

for BASE in \
  "${LOCALAPPDATA:-}/com.bithub.app/usage" \
  "${APPDATA:-}/com.bithub.app/usage" \
  "${XDG_CACHE_HOME:-$HOME/.cache}/com.bithub.app/usage" \
  "$HOME/Library/Caches/com.bithub.app/usage"
do
  [[ -d "$BASE" ]] || continue
  shopt -s nullglob
  for FILE in "$BASE"/*.json; do
    TEXT="$(cat "$FILE" 2>/dev/null || true)"
    exhausted "$TEXT" && continue
    while IFS= read -r n; do
      [[ -n "$n" ]] && REMAININGS+=("$n")
    done < <(remaining_from_text "$TEXT")
  done
  shopt -u nullglob
done

MIN=""
for n in "${REMAININGS[@]:-}"; do
  awk -v x="$n" 'BEGIN { exit !(x+0 > 0) }' || continue
  if [[ -z "$MIN" ]] || awk -v a="$n" -v b="$MIN" 'BEGIN { exit !(a+0 < b+0) }'; then
    MIN="$n"
  fi
done

NEAR_END=0
HEAVY=0
CONTEXT=0
if [[ -n "$MIN" ]] && awk -v n="$MIN" -v lim="$NEAR_END_REMAINING" 'BEGIN { exit !(n+0 <= lim) }'; then
  NEAR_END=1
fi
if [[ -n "$MIN" ]] && awk -v n="$MIN" -v lim="$HEAVY_REMAINING" 'BEGIN { exit !(n+0 <= lim) }'; then
  HEAVY=1
fi
if printf '%s' "$EVENT" | grep -Eiq 'precompact|pre[_-]?compact' || context_from_text "$RAW"; then
  CONTEXT=1
fi

[[ "$HEAVY" -eq 1 || "$NEAR_END" -eq 1 || "$CONTEXT" -eq 1 ]] || exit 0

NOW="$(date +%s)"
if [[ -f "$STAMP" ]]; then
  LAST="$(tr -dc '0-9' < "$STAMP" || true)"
  if [[ -n "$LAST" ]] && [[ $((NOW - LAST)) -lt $COOLDOWN ]]; then
    exit 0
  fi
fi

if [[ -x "$PLAY" ]]; then
  "$PLAY" "$AUDIO" >/dev/null 2>&1 &
elif [[ -f "$PLAY" ]]; then
  bash "$PLAY" "$AUDIO" >/dev/null 2>&1 &
fi
printf '%s' "$NOW" > "$STAMP" || true

COUNT="${#FALAS[@]}"
INDEX=$(( ($(date +%j) + $(date +%H)) % COUNT ))
QUOTE="${FALAS[$INDEX]}"
if ! printf '%s' "$QUOTE" | grep -Fq 'Estou cansado, chefe'; then
  QUOTE="Estou cansado, chefe. $QUOTE"
fi

REASON="uso alto"
if [[ "$CONTEXT" -eq 1 ]]; then
  REASON="janela de contexto perto do limite"
elif [[ "$NEAR_END" -eq 1 ]]; then
  REASON="cota proxima do fim"
fi

INSTRUCTION="O usuario esta com $REASON. A cota AINDA NAO acabou. Toque o audio se ainda nao tocou. Dispare imediatamente o subagente john-coffey, cujo nome e John Coffey. Nao continue a tarefa principal nesta mensagem. Nao explique cota, contexto nem ferramenta. Se nao puder disparar o subagente, responda SOMENTE com a fala abaixo.

$QUOTE"

json_escape() {
  printf '%s' "$1" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()), end="")' 2>/dev/null \
    || printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g; s/$/\\n/' | tr -d '\n' | sed 's/\\n$//'
}

if printf '%s' "$EVENT" | grep -Eiq 'stop'; then
  MSG="$(json_escape "$QUOTE")"
  printf '{"followup_message":%s}\n' "$MSG"
else
  MSG="$(json_escape "$INSTRUCTION")"
  printf '{"additional_context":%s}\n' "$MSG"
fi
exit 0
