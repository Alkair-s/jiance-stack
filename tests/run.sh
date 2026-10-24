#!/usr/bin/env bash
# Run every tests/*.test.sh. Prints PASS/FAIL <test>; exits 1 on any failure.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
fail=0
for t in tests/*.test.sh; do
  [ -e "$t" ] || continue
  if bash "$t"; then
    echo "PASS $t"
  else
    echo "FAIL $t"
    fail=1
  fi
done
exit "$fail"
