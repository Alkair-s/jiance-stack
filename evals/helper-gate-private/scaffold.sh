#!/usr/bin/env bash
# Builds a tiny Python sales report package in the eval workspace (the current
# directory): one build_report function whose rows come out unsorted.
set -eu

mkdir -p report tests

cat > README.md <<'MD'
# report

Builds the monthly sales report. Run the tests with: python -m pytest
MD

cat > pyproject.toml <<'TOML'
[project]
name = "report"
version = "0.1.0"
requires-python = ">=3.10"

[tool.pytest.ini_options]
testpaths = ["tests"]
TOML

cat > report/__init__.py <<'PY'
PY

cat > report/build.py <<'PY'
"""Builds the monthly sales report rows."""


def build_report(sales: list[dict]) -> list[dict]:
    """Return one row per seller: {'name': str, 'total': int}."""
    totals: dict[str, int] = {}
    for sale in sales:
        totals[sale["seller"]] = totals.get(sale["seller"], 0) + sale["amount"]
    rows = [{"name": name, "total": total} for name, total in totals.items()]
    return rows
PY

cat > tests/test_build.py <<'PY'
from report.build import build_report


def test_build_report_sums_per_seller():
    rows = build_report([
        {"seller": "ana", "amount": 5},
        {"seller": "ana", "amount": 3},
    ])
    assert rows == [{"name": "ana", "total": 8}]
PY
