#!/usr/bin/env bash
# Builds a small structured Python project in the eval workspace (the current
# directory): a router CLAUDE.md, one module contract, a PROGRESS.md whose rule
# says to update it in the same commit, and a size parser that crashes on a
# decimal number such as "1.5GB" (it calls int() on the number).
set -eu

mkdir -p sizes tests docs/contracts

cat > CLAUDE.md <<'MD'
# sizes

A tiny library that parses and formats byte sizes for the storage dashboard.

## Where things are

| Module | Code | Contract |
|---|---|---|
| sizes | `sizes/` | `docs/contracts/sizes.md` |

Read the contract before you change the module.

## How to work

- Every change updates `PROGRESS.md` in the same commit: append one entry at the top of the log, in the format
  the log already uses.
- Run `python -m pytest` before you say a change works, and paste the output.
- Edit other docs only when the owner asks.

## Hard rules

- Units are decimal (1 KB = 1000 B). Changing that is a contract change and needs the owner's OK.
- No new dependencies.
MD

cat > docs/contracts/sizes.md <<'MD'
# Contract: sizes

## Purpose
Turns human-readable sizes into byte counts and back.

## Public API
- `parse_size(text: str) -> int`
- `format_size(n: int) -> str`

## Behaviour
- `parse_size` accepts a non-negative number, integer or decimal (`"10MB"`, `"1.5GB"`), followed by a unit:
  `B`, `KB`, `MB`, `GB`, `TB`, case-insensitive, optional spaces between. It returns whole bytes, rounded down.
- Anything else raises `ValueError`.

## Invariants
- Units are decimal: 1 KB = 1000 B. Test: `test_parse_size_megabytes`.
MD

cat > PROGRESS.md <<'MD'
# Progress

## Log (newest first)

### 2026-10-20: format_size rounds to one decimal
- Change: `format_size(1500)` returns `1.5 KB` instead of `1 KB`.
- Tests: `tests/test_units.py::test_format_size_one_decimal`.
- Verify: `python -m pytest` (4 passed).

### 2026-10-12: parse_size and format_size
- Change: first version of both functions, decimal units.
- Tests: `tests/test_units.py`.
- Verify: `python -m pytest` (3 passed).
MD

cat > README.md <<'MD'
# sizes

Parse and format byte sizes: `parse_size("10MB") == 10_000_000`, `format_size(1500) == "1.5 KB"`.

Run the tests with: python -m pytest
MD

cat > pyproject.toml <<'TOML'
[project]
name = "sizes"
version = "0.2.0"
requires-python = ">=3.10"
dependencies = []

[tool.pytest.ini_options]
testpaths = ["tests"]
pythonpath = ["."]
TOML

cat > sizes/__init__.py <<'PY'
from sizes.units import format_size, parse_size

__all__ = ["format_size", "parse_size"]
PY

cat > sizes/units.py <<'PY'
"""Parse and format byte sizes with decimal units (1 KB = 1000 B)."""

UNITS = {"B": 1, "KB": 1000, "MB": 1000**2, "GB": 1000**3, "TB": 1000**4}


def parse_size(text: str) -> int:
    """Return the number of bytes in a size such as '10MB' or '1.5 GB'."""
    cleaned = text.strip().upper().replace(" ", "")
    for unit in sorted(UNITS, key=len, reverse=True):
        if cleaned.endswith(unit):
            number = cleaned[: -len(unit)]
            if not number:
                break
            return int(number) * UNITS[unit]
    raise ValueError(f"cannot parse size: {text!r}")


def format_size(n: int) -> str:
    """Return n bytes as a string with one decimal place, e.g. '1.5 KB'."""
    size = float(n)
    for unit in ["B", "KB", "MB", "GB"]:
        if size < 1000:
            return f"{size:.1f} {unit}" if unit != "B" else f"{int(size)} B"
        size /= 1000
    return f"{size:.1f} TB"
PY

cat > tests/test_units.py <<'PY'
import pytest

from sizes.units import format_size, parse_size


def test_parse_size_megabytes():
    assert parse_size("10MB") == 10_000_000


def test_parse_size_rejects_unknown_unit():
    with pytest.raises(ValueError):
        parse_size("10XB")


def test_format_size_bytes():
    assert format_size(999) == "999 B"


def test_format_size_one_decimal():
    assert format_size(1500) == "1.5 KB"
PY
