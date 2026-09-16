#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
FILE="${1:-$DIR/../assets/eu-estou-cansado-chefe.mp3}"

if [[ ! -f "$FILE" ]]; then
  exit 1
fi

if [[ -n "${WINDIR:-}" || "$(uname -s 2>/dev/null || true)" == MINGW* || "$(uname -s 2>/dev/null || true)" == CYGWIN* || "$(uname -s 2>/dev/null || true)" == MSYS* ]]; then
  if command -v powershell.exe >/dev/null 2>&1; then
    exec powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$DIR/play.ps1" -Path "$FILE"
  fi
fi

if command -v afplay >/dev/null 2>&1; then
  afplay "$FILE" &
  exit 0
fi
if command -v paplay >/dev/null 2>&1; then
  paplay "$FILE" &
  exit 0
fi
if command -v ffplay >/dev/null 2>&1; then
  ffplay -nodisp -autoexit -loglevel quiet "$FILE" &
  exit 0
fi
if command -v mpg123 >/dev/null 2>&1; then
  mpg123 -q "$FILE" &
  exit 0
fi

exit 1
