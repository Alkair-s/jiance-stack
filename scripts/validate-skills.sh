#!/usr/bin/env bash
# Usage: validate-skills.sh [skills-dir] [UPSTREAM.md]
# Exit 0 when valid, 1 otherwise. One "FAIL <skill>: <why>" line per problem.
set -uo pipefail

skills_dir="${1:-skills}"
upstream="${2:-$(dirname "$skills_dir")/UPSTREAM.md}"
fail=0

bad() { echo "FAIL $1: $2"; fail=1; }

trim() { local s="$1"; s="${s#"${s%%[![:space:]]*}"}"; s="${s%"${s##*[![:space:]]}"}"; printf '%s' "$s"; }

# Skills listed in the UPSTREAM.md table (first column of data rows).
adapted=()
if [ -f "$upstream" ]; then
  while IFS= read -r line; do
    line="${line%$'\r'}"
    case "$line" in "|"*) ;; *) continue ;; esac
    cell="${line#|}"; cell="${cell%%|*}"; cell="$(trim "$cell")"
    case "$cell" in ""|skill|-*|:*) continue ;; esac
    adapted+=("$cell")
  done < "$upstream"
fi

is_adapted() {
  local a
  for a in ${adapted[@]+"${adapted[@]}"}; do [ "$a" = "$1" ] && return 0; done
  return 1
}

for dir in "$skills_dir"/*/; do
  [ -d "$dir" ] || continue
  skill="$(basename "$dir")"
  file="$dir/SKILL.md"
  if [ ! -f "$file" ]; then bad "$skill" "SKILL.md missing"; continue; fi

  name=""; desc=""; infm=0; closed=0; n=0; after=""
  while IFS= read -r line || [ -n "$line" ]; do
    line="${line%$'\r'}"
    n=$((n + 1))
    if [ "$n" -eq 1 ]; then
      [ "$line" = "---" ] || break
      infm=1; continue
    fi
    if [ "$infm" -eq 1 ]; then
      if [ "$line" = "---" ]; then infm=0; closed=1; continue; fi
      case "$line" in
        name:*) name="$(trim "${line#name:}")" ;;
        description:*) desc="$(trim "${line#description:}")" ;;
      esac
    elif [ "$closed" -eq 1 ] && [ -z "$after" ]; then
      [ -n "$(trim "$line")" ] && after="$line"
    fi
  done < "$file"

  if [ "$closed" -ne 1 ]; then bad "$skill" "frontmatter missing or unterminated"; continue; fi
  [ "$name" = "$skill" ] || bad "$skill" "name '$name' does not match directory"
  [ -n "$desc" ] || bad "$skill" "description missing or empty"
  if is_adapted "$skill"; then
    case "$after" in
      "> Adapted from "*) ;;
      *) bad "$skill" "credit line missing right after frontmatter" ;;
    esac
  fi
done

# A row whose first cell holds a "/" names an adapted file (e.g. hooks/run-hook.cmd),
# relative to the directory of UPSTREAM.md; any other row names a skill.
for a in ${adapted[@]+"${adapted[@]}"}; do
  case "$a" in
    */*) [ -f "$(dirname "$upstream")/$a" ] || bad "$a" "file listed in UPSTREAM.md does not exist" ;;
    *) [ -f "$skills_dir/$a/SKILL.md" ] || bad "$a" "listed in UPSTREAM.md but skill does not exist" ;;
  esac
done

exit "$fail"
