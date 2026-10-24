#!/usr/bin/env bash
# Test helpers. Source this file from a *.test.sh.

assert_exit() {
  local expected="$1"; shift
  "$@" >/dev/null 2>&1
  local got=$?
  if [ "$got" -ne "$expected" ]; then
    echo "  expected exit $expected, got $got: $*" >&2
    return 1
  fi
}

assert_output_contains() {
  local text="$1"; shift
  local out
  out="$("$@" 2>&1)"
  case "$out" in
    *"$text"*) return 0 ;;
  esac
  echo "  output lacks '$text': $*" >&2
  echo "  got: $out" >&2
  return 1
}
