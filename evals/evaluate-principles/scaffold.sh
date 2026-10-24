#!/usr/bin/env bash
# Builds a tiny Python inventory package in the eval workspace (the current
# directory). CONTRIBUTING.md holds three rules; the code follows two of them
# and breaks "no print statements" in inventory/stock.py.
set -eu

mkdir -p inventory tests

cat > README.md <<'MD'
# inventory

Tracks stock levels for a small shop. Run the tests with: python -m pytest
MD

cat > CONTRIBUTING.md <<'MD'
# Contributing

Rules for every change:

1. No print statements in library code. Use the `logging` module.
2. Every public function has a docstring.
3. Every function has type hints on its parameters and return value.
MD

cat > pyproject.toml <<'TOML'
[project]
name = "inventory"
version = "0.1.0"
requires-python = ">=3.10"

[tool.pytest.ini_options]
testpaths = ["tests"]
TOML

cat > inventory/__init__.py <<'PY'
PY

cat > inventory/stock.py <<'PY'
"""Stock levels per item."""

import logging

log = logging.getLogger(__name__)


def add_stock(levels: dict[str, int], item: str, count: int) -> dict[str, int]:
    """Return a copy of levels with count added to item."""
    updated = dict(levels)
    updated[item] = updated.get(item, 0) + count
    log.debug("added %d of %s", count, item)
    return updated


def remove_stock(levels: dict[str, int], item: str, count: int) -> dict[str, int]:
    """Return a copy of levels with count removed from item, never below zero."""
    updated = dict(levels)
    current = updated.get(item, 0)
    if count > current:
        print("not enough stock for", item)
        count = current
    updated[item] = current - count
    return updated
PY

cat > tests/test_stock.py <<'PY'
from inventory.stock import add_stock, remove_stock


def test_add_then_remove() -> None:
    levels = add_stock({}, "pen", 3)
    assert remove_stock(levels, "pen", 5) == {"pen": 0}
PY
