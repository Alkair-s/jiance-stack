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

# JSON escaping: run a copy of the hook in a fake plugin root whose router holds
# double quotes, backslashes and a tab, and check the output is one escaped line.
fake="$tmp/plugin"
mkdir -p "$fake/hooks" "$fake/skills/using-jiance"
cp "$H" "$fake/hooks/session-start"
printf 'say "hi" at C:\\dir\\file\tend\nsecond line\n' > "$fake/skills/using-jiance/SKILL.md"

escaped_json() {
  local out
  out="$(env HOME="$clean" bash "$fake/hooks/session-start" 2>&1)"
  case "$out" in
    *$'\n'*) echo "  output spans more than one line: $out" >&2; return 1 ;;
  esac
  case "$out" in
    *'say \"hi\" at C:\\dir\\file\tend\nsecond line'*) return 0 ;;
  esac
  echo "  escaping wrong: $out" >&2
  return 1
}
run_case "escapes quotes, backslashes, tabs and newlines" escaped_json

exit "$rc"
