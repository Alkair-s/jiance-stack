#!/usr/bin/env bash
# Tests for hooks/session-start. Each case prints ok/FAIL <case>.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
. tests/lib.sh

H=hooks/session-start
rc=0
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

run_case() {
  local name="$1"; shift
  if "$@"; then echo "  ok: $name"; else echo "  FAIL: $name"; rc=1; fi
}

# A fake HOME with no plugins, and one with a superpowers manifest.
clean="$tmp/clean"
dirty="$tmp/dirty"
mkdir -p "$clean" "$dirty/.claude/plugins/x/superpowers/.claude-plugin"
printf '{"name":"superpowers"}\n' > "$dirty/.claude/plugins/x/superpowers/.claude-plugin/plugin.json"

run_case "emits router context" \
  assert_output_contains '"additionalContext"' env HOME="$clean" bash "$H"
run_case "context names the router" \
  assert_output_contains 'using-jiance' env HOME="$clean" bash "$H"
run_case "detects superpowers" \
  assert_output_contains 'disable it' env HOME="$dirty" bash "$H"

no_warning() {
  local out
  out="$(env HOME="$clean" bash "$H" 2>&1)"
  case "$out" in
    *"disable it"*) echo "  unexpected warning: $out" >&2; return 1 ;;
  esac
  return 0
}
run_case "no warning when absent" no_warning

run_case "runs with empty PATH (exit)" \
  assert_exit 0 env -i HOME="$clean" "$BASH" "$H"
run_case "runs with empty PATH (context)" \
  assert_output_contains 'using-jiance' env -i HOME="$clean" "$BASH" "$H"

exit "$rc"
