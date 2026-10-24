#!/usr/bin/env bash
# Builds a small Python package with code only: no README, no CLAUDE.md, no
# contracts, no decision log, no progress file, no changelog.
set -eu

mkdir -p invoices tests

cat > pyproject.toml <<'TOML'
[project]
name = "invoices"
version = "0.3.0"
requires-python = ">=3.10"
TOML

cat > invoices/__init__.py <<'PY'
PY

cat > invoices/totals.py <<'PY'
from decimal import Decimal


def line_total(qty: int, unit_price: Decimal) -> Decimal:
    return Decimal(qty) * unit_price


def invoice_total(lines: list[tuple[int, Decimal]], vat_rate: Decimal) -> Decimal:
    net = sum((line_total(q, p) for q, p in lines), Decimal("0"))
    return (net * (1 + vat_rate)).quantize(Decimal("0.01"))
PY

cat > invoices/render.py <<'PY'
from decimal import Decimal

from invoices.totals import invoice_total


def render_text(customer: str, lines: list[tuple[int, Decimal]], vat_rate: Decimal) -> str:
    total = invoice_total(lines, vat_rate)
    return f"Invoice for {customer}\nTotal: {total}\n"
PY

cat > tests/test_totals.py <<'PY'
from decimal import Decimal

from invoices.totals import invoice_total


def test_total_with_vat() -> None:
    assert invoice_total([(2, Decimal("10.00"))], Decimal("0.20")) == Decimal("24.00")
PY
