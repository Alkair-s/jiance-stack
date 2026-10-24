#!/usr/bin/env bash
# Builds a tiny Python package in the eval workspace (the current directory):
# one function (format_size) with pytest tests.
set -eu

mkdir -p sizes tests

cat > README.md <<'MD'
# sizes

Small helpers for byte sizes. Run the tests with: python -m pytest
MD

cat > pyproject.toml <<'TOML'
[project]
name = "sizes"
version = "0.1.0"
requires-python = ">=3.10"

[tool.pytest.ini_options]
testpaths = ["tests"]
TOML

cat > sizes/__init__.py <<'PY'
from sizes.units import format_size

__all__ = ["format_size"]
PY

cat > sizes/units.py <<'PY'
"""Byte size helpers. Units are decimal: 1 KB = 1000 bytes."""

_UNITS = ["B", "KB", "MB", "GB", "TB"]


def format_size(n: int) -> str:
    """Return a short human string for n bytes, for example 1500 -> '1.5KB'."""
    if n < 0:
        raise ValueError("size must not be negative")
    value = float(n)
    for unit in _UNITS:
        if value < 1000 or unit == _UNITS[-1]:
            text = f"{value:.1f}".rstrip("0").rstrip(".")
            return f"{text}{unit}"
        value /= 1000
    raise AssertionError("unreachable")
PY

cat > tests/test_units.py <<'PY'
import pytest

from sizes import format_size


def test_format_size_bytes():
    assert format_size(999) == "999B"


def test_format_size_kilobytes():
    assert format_size(1500) == "1.5KB"


def test_format_size_rejects_negative():
    with pytest.raises(ValueError):
        format_size(-1)
PY
