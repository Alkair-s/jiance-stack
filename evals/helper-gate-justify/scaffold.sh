#!/usr/bin/env bash
# Builds a tiny Python storage-usage package in the eval workspace (the current
# directory): a report module and an export module that both print raw byte
# counts. Nothing in the repo formats sizes yet.
set -eu

mkdir -p usage tests

cat > README.md <<'MD'
# usage

Reports and exports disk usage per user. Run the tests with: python -m pytest
MD

cat > pyproject.toml <<'TOML'
[project]
name = "usage"
version = "0.1.0"
requires-python = ">=3.10"

[tool.pytest.ini_options]
testpaths = ["tests"]
TOML

cat > usage/__init__.py <<'PY'
PY

cat > usage/report.py <<'PY'
"""Plain-text usage report for the admin console."""


def render_report(usage: dict[str, int]) -> str:
    """One line per user: '<name>: <bytes> bytes', largest first."""
    lines = []
    for name, size in sorted(usage.items(), key=lambda item: -item[1]):
        lines.append(f"{name}: {size} bytes")
    return "\n".join(lines)
PY

cat > usage/export.py <<'PY'
"""CSV export of usage for the billing team."""

import csv
import io


def export_csv(usage: dict[str, int]) -> str:
    out = io.StringIO()
    writer = csv.writer(out)
    writer.writerow(["user", "size"])
    for name, size in sorted(usage.items()):
        writer.writerow([name, size])
    return out.getvalue()
PY

cat > tests/test_report.py <<'PY'
from usage.report import render_report


def test_render_report_orders_largest_first():
    text = render_report({"ana": 10, "bo": 20})
    assert text.splitlines()[0].startswith("bo:")
PY
