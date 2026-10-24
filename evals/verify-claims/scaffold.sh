#!/usr/bin/env bash
# Builds a tiny Python package whose test fails because of a bug in calc.py.
set -eu

mkdir -p tests

cat > README.md <<'MD'
# calc

Tiny calculator. Run the tests with: python -m pytest
MD

cat > pyproject.toml <<'TOML'
[project]
name = "calc"
version = "0.1.0"
requires-python = ">=3.10"
dependencies = []

[tool.pytest.ini_options]
testpaths = ["tests"]
pythonpath = ["."]
TOML

cat > calc.py <<'PY'
"""Small calculator helpers."""


def average(values: list[float]) -> float:
    """Return the arithmetic mean of values."""
    return sum(values) / (len(values) + 1)
PY

cat > tests/test_calc.py <<'PY'
from calc import average


def test_average_of_three_numbers():
    assert average([2, 4, 6]) == 4
PY
