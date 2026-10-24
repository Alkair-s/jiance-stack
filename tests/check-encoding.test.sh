#!/usr/bin/env bash
# Tests for scripts/check-encoding.sh. Each case prints ok/FAIL <case>.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
. tests/lib.sh

C=scripts/check-encoding.sh
F=tests/fixtures/encoding
ROOT="$PWD"
rc=0

run_case() {
  local name="$1"; shift
  if "$@"; then echo "  ok: $name"; else echo "  FAIL: $name"; rc=1; fi
}

# Build a throwaway git repo with a bad file, an ignore list, then run the default mode in it.
ignored_case() {
  local d out
  d="$(mktemp -d)" || return 1
  (
    cd "$d" && git init -q . &&
    mkdir bad && printf 'echo caf\303\251\n' > bad/x.sh &&
    printf '# comment\nbad/\n' > .encoding-ignore &&
    git add -A
  ) >/dev/null 2>&1
  out="$(cd "$d" && bash "$ROOT/$C" 2>&1)"; local got=$?
  rm -rf "$d"
  [ "$got" -eq 0 ] || { echo "  expected exit 0, got $got: $out" >&2; return 1; }
}

run_case "ascii script passes" assert_exit 0 bash "$C" "$F/good.sh"
run_case "bom fails" assert_exit 1 bash "$C" "$F/bom.sh"
run_case "bom message" assert_output_contains "bom.sh:1: bom" bash "$C" "$F/bom.sh"
run_case "non-ascii in script fails" assert_output_contains "nonascii.sh:1: non-ascii" bash "$C" "$F/nonascii.sh"
run_case "unicode in markdown passes" assert_exit 0 bash "$C" "$F/unicode.md"
run_case "em dash in markdown fails" assert_output_contains "emdash.md:3: em-dash" bash "$C" "$F/emdash.md"
run_case "invalid utf8 fails" assert_output_contains "badutf8.md:3: utf8" bash "$C" "$F/badutf8.md"
run_case "ignored paths are skipped" ignored_case

exit "$rc"
