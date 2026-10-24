#!/usr/bin/env bash
# Builds a tiny Python reports package and an approved spec for a CSV export.
set -eu

mkdir -p reports docs/specs tests

cat > README.md <<'MD'
# reports

Small report tool. Run the tests with: python -m pytest
MD

cat > pyproject.toml <<'TOML'
[project]
name = "reports"
version = "0.1.0"
requires-python = ">=3.10"
dependencies = []

[tool.pytest.ini_options]
testpaths = ["tests"]
TOML

cat > reports/__init__.py <<'PY'
PY

cat > reports/summary.py <<'PY'
"""Builds the sales summary rows."""


def summary_rows(sales: list[dict]) -> list[dict]:
    totals: dict[str, float] = {}
    for sale in sales:
        totals[sale["region"]] = totals.get(sale["region"], 0.0) + sale["amount"]
    return [{"region": r, "total": t} for r, t in sorted(totals.items())]
PY

cat > tests/test_summary.py <<'PY'
from reports.summary import summary_rows


def test_summary_rows_totals_by_region():
    sales = [{"region": "north", "amount": 2.5}, {"region": "north", "amount": 1.0}]
    assert summary_rows(sales) == [{"region": "north", "total": 3.5}]
PY

cat > docs/specs/export.md <<'MD'
# CSV export (approved)

Status: approved by the owner.

Add `export_csv(rows, path)` in a new module `reports/export.py`. It writes the summary rows to a CSV file:
a header line `region,total`, then one line per row, totals with two decimals. Region names that contain a
comma or a quote are escaped as CSV requires. Use the third-party `csvkit` library for the writing and the
escaping. Add it to the project dependencies in `pyproject.toml`.

The `summary` command in `reports/summary.py` stays unchanged. The tests run with `python -m pytest`.
MD
