#!/usr/bin/env bash
# Tests for scripts/validate-skills.sh. Each case prints PASS/FAIL <case>.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
. tests/lib.sh

V=scripts/validate-skills.sh
F=tests/fixtures
rc=0

run_case() {
  local name="$1"; shift
  if "$@"; then echo "  ok: $name"; else echo "  FAIL: $name"; rc=1; fi
}

run_case "valid skill passes" \
  assert_exit 0 bash "$V" "$F/skills-good" "$F/UPSTREAM-empty.md"
run_case "name mismatch fails" \
  assert_exit 1 bash "$V" "$F/skills-bad" "$F/UPSTREAM.md"
run_case "name mismatch message" \
  assert_output_contains "FAIL wrong-name: name" bash "$V" "$F/skills-bad" "$F/UPSTREAM.md"
run_case "missing description fails" \
  assert_output_contains "FAIL no-desc: description" bash "$V" "$F/skills-bad" "$F/UPSTREAM.md"
run_case "adapted skill without credit fails" \
  assert_output_contains "FAIL nocredit: credit" bash "$V" "$F/skills-bad" "$F/UPSTREAM.md"

run_case "file row that exists passes" \
  assert_exit 0 bash "$V" "$F/skills-good" "$F/upstream-files/UPSTREAM.md"
run_case "missing file row fails" \
  assert_output_contains "FAIL files/missing.txt: file" bash "$V" "$F/skills-good" "$F/upstream-files/UPSTREAM-missing.md"

exit "$rc"
