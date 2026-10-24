#!/usr/bin/env bash
# Encoding check (P3). Usage: check-encoding.sh [paths...]
# Default: every git-tracked file under the repo root, minus .encoding-ignore globs.
# Explicit paths (files, or directories recursively) are always checked.
# Rules: bom, utf8 (invalid UTF-8), em-dash (U+2014), non-ascii (source files only).
# Docs = *.md, *.txt, plus globs listed in .encoding-docs. Everything else is source.
# Output: FAIL <file>:<line>: <rule>. Exit 1 if any failure.
export LC_ALL=C
set -u

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
fail=0

read_globs() {
  [ -f "$1" ] || return 0
  grep -v '^[[:space:]]*#' "$1" | tr -d '\r' | grep -v '^[[:space:]]*$'
}

docs_globs="$(read_globs "$root/.encoding-docs")"
ignore_globs="$(read_globs "$root/.encoding-ignore")"

matches_any() { # path, globs
  local p="$1" g
  while IFS= read -r g; do
    [ -n "$g" ] || continue
    case "$g" in */) g="$g*" ;; esac
    # shellcheck disable=SC2254
    case "$p" in $g) return 0 ;; esac
    # shellcheck disable=SC2254
    case "${p##*/}" in $g) return 0 ;; esac
  done <<< "$2"
  return 1
}

is_doc() {
  case "$1" in *.md|*.txt) return 0 ;; esac
  matches_any "$1" "$docs_globs"
}

utf8_re='^([\x00-\x7F]|[\xC2-\xDF][\x80-\xBF]|\xE0[\xA0-\xBF][\x80-\xBF]|[\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}|\xED[\x80-\x9F][\x80-\xBF]|\xF0[\x90-\xBF][\x80-\xBF]{2}|[\xF1-\xF3][\x80-\xBF]{3}|\xF4[\x80-\x8F][\x80-\xBF]{2})*$'

# scan <grep opts> <pattern> <file>: print matching line numbers; status 2 on grep error.
scan() {
  local o
  o="$(grep "$@")"; local s=$?
  [ "$s" -ge 2 ] && return 2
  printf '%s\n' "$o" | cut -d: -f1
}

check_file() {
  local f="$1" out
  [ -f "$f" ] || { echo "FAIL $f: read-error"; fail=1; return 0; }
  # Skip binary files (NUL byte present).
  if [ -s "$f" ] && [ "$(tr -d '\000' < "$f" | wc -c)" -ne "$(wc -c < "$f")" ]; then return 0; fi
  if [ "$(head -c 3 "$f" | od -An -tx1 | tr -d ' \n')" = "efbbbf" ]; then
    echo "FAIL $f:1: bom"; fail=1
  fi
  out="$(scan -nvP "$utf8_re" "$f")" || { echo "FAIL $f: read-error"; fail=1; return 0; }
  if [ -n "$out" ]; then
    while IFS= read -r n; do echo "FAIL $f:$n: utf8"; done <<< "$out"; fail=1
  fi
  out="$(scan -nP '\xE2\x80\x94' "$f")" || { echo "FAIL $f: read-error"; fail=1; return 0; }
  if [ -n "$out" ]; then
    while IFS= read -r n; do echo "FAIL $f:$n: em-dash"; done <<< "$out"; fail=1
  fi
  if ! is_doc "$f"; then
    out="$(scan -nP '[\x80-\xFF]' "$f")" || { echo "FAIL $f: read-error"; fail=1; return 0; }
    if [ -n "$out" ]; then
      while IFS= read -r n; do echo "FAIL $f:$n: non-ascii"; done <<< "$out"; fail=1
    fi
  fi
}

if [ "$#" -eq 0 ]; then
  cd "$root" || exit 1
  while IFS= read -r -d '' f; do
    matches_any "$f" "$ignore_globs" && continue
    check_file "$f"
  done < <(git ls-files -z)
else
  for p in "$@"; do
    if [ -d "$p" ]; then
      while IFS= read -r f; do check_file "$f"; done < <(find "$p" -type f -not -path '*/.git/*' | sort)
    else
      check_file "$p"
    fi
  done
fi
exit "$fail"
