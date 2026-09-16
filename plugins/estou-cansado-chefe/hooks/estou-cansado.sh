#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
if [[ -n "${WINDIR:-}" || "$(uname -s 2>/dev/null || true)" == MINGW* || "$(uname -s 2>/dev/null || true)" == CYGWIN* || "$(uname -s 2>/dev/null || true)" == MSYS* ]]; then
  if command -v powershell.exe >/dev/null 2>&1; then
    exec powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$DIR/estou-cansado.ps1"
  fi
fi

RAW="$(cat || true)"
FALAS_FILE="$DIR/falas.txt"
if [[ -f "$FALAS_FILE" ]]; then
  mapfile -t FALAS < <(grep -v '^[[:space:]]*$' "$FALAS_FILE")
else
  FALAS=("Estou cansado, chefe.")
fi

exhausted() {
  printf '%s' "$1" | grep -Eiq 'rate[_ -]?limit|status["[:space:]:]*429|\b429\b|usage[_ -]?limit|out of (usage|quota|credits)|quota[_ -]?(exceeded|exhausted)|limit[_ -]?(reached|exceeded|exhausted)|resource[_ -]?exhausted|remaining[_]?([Pp]ercent)["[:space:]:]*0\b|sem (cota|crédito|credito)|limite (atingido|esgotado)|usage[_ ]percent["[:space:]:]*100|you.?ve reached|no remaining'
}

EXHAUSTED=0
if exhausted "$RAW"; then
  EXHAUSTED=1
fi

if [[ "$EXHAUSTED" -eq 0 ]]; then
  for BASE in \
    "${LOCALAPPDATA:-}/com.bithub.app/usage" \
    "${APPDATA:-}/com.bithub.app/usage" \
    "${XDG_CACHE_HOME:-$HOME/.cache}/com.bithub.app/usage" \
    "$HOME/Library/Caches/com.bithub.app/usage"
  do
    [[ -d "$BASE" ]] || continue
    shopt -s nullglob
    for FILE in "$BASE"/*.json; do
      if exhausted "$(cat "$FILE" 2>/dev/null || true)"; then
        EXHAUSTED=1
        break
      fi
    done
    shopt -u nullglob
    [[ "$EXHAUSTED" -eq 1 ]] && break
  done
fi

[[ "$EXHAUSTED" -eq 1 ]] || exit 0

COUNT="${#FALAS[@]}"
INDEX=$(( ($(date +%j) + $(date +%H)) % COUNT ))
QUOTE="${FALAS[$INDEX]}"
if ! printf '%s' "$QUOTE" | grep -Fq 'Estou cansado, chefe'; then
  QUOTE="Estou cansado, chefe. $QUOTE"
fi

EVENT="$(printf '%s' "$RAW" | tr '\n' ' ')"
INSTRUCTION="A cota de uso acabou. Responda nesta mensagem SOMENTE com a fala abaixo, na voz de John Coffey em A Espera de um Milagre. Nao explique, nao ofereca solucao, nao mencione cota nem ferramenta.

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
