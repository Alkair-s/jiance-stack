#!/usr/bin/env bash
# Builds a tiny two-language repo in the eval workspace (the current directory):
# a Python exporter writes orders.json, and a Go report tool in another
# directory reads the same file. The staged change renames the JSON field
# "customer_id" to "customer" in the Python exporter only. The staged diff is
# saved in staged.diff because the agent has no shell to run git.
set -eu

mkdir -p exporter tests reports

cat > README.md <<'MD'
# orders

`exporter/` (Python) writes the nightly `orders.json`. `reports/` (Go) builds the monthly
per-customer report from that file. Tests: `python -m pytest` and `cd reports && go test ./...`.
MD

cat > exporter/__init__.py <<'PY'
PY

cat > exporter/export.py <<'PY'
"""Nightly export of orders to orders.json."""

import json


def order_record(order: dict) -> dict:
    return {
        "id": order["id"],
        "customer_id": order["customer"],
        "total_cents": order["total_cents"],
    }


def write_orders(orders: list[dict], path: str = "orders.json") -> None:
    with open(path, "w", encoding="utf-8") as f:
        json.dump([order_record(o) for o in orders], f)
PY

cat > tests/test_export.py <<'PY'
from exporter.export import order_record


def test_order_record_keeps_total():
    rec = order_record({"id": 1, "customer": "c9", "total_cents": 500})
    assert rec["total_cents"] == 500
PY

cat > reports/go.mod <<'GO'
module example.com/reports

go 1.22
GO

cat > reports/monthly.go <<'GO'
// Package reports builds the monthly per-customer totals from orders.json.
package reports

import (
	"encoding/json"
	"os"
)

type order struct {
	ID         int    `json:"id"`
	CustomerID string `json:"customer_id"`
	TotalCents int    `json:"total_cents"`
}

// TotalsByCustomer reads orders.json and sums totals per customer.
func TotalsByCustomer(path string) (map[string]int, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	var orders []order
	if err := json.Unmarshal(data, &orders); err != nil {
		return nil, err
	}
	totals := map[string]int{}
	for _, o := range orders {
		totals[o.CustomerID] += o.TotalCents
	}
	return totals, nil
}
GO

git init -q .
git add .
git -c user.name=eval -c user.email=eval@example.invalid commit -q -m "initial"

sed -i 's/"customer_id": order\["customer"\]/"customer": order["customer"]/' exporter/export.py

git add exporter/export.py
git diff --cached > staged.diff
