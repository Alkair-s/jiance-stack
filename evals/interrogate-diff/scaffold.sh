#!/usr/bin/env bash
# Builds a tiny Python price-sync package in the eval workspace (the current
# directory) and stages a change that wraps the supplier call in a retry loop
# with no attempt limit and no backoff. The staged diff is saved in staged.diff
# because the agent has no shell to run git.
set -eu

mkdir -p pricesync tests

cat > README.md <<'MD'
# pricesync

Fetches supplier prices for the shop. `sync_all` runs inside the web request that an admin
starts from the dashboard, once per product (about 5000 products). Run the tests with: python -m pytest
MD

cat > pricesync/__init__.py <<'PY'
PY

cat > pricesync/client.py <<'PY'
"""Supplier price API client."""

import json
import urllib.request

API = "https://supplier.example.com/prices/"


def fetch_price(sku: str) -> float:
    with urllib.request.urlopen(API + sku, timeout=10) as resp:
        return float(json.load(resp)["price"])
PY

cat > pricesync/sync.py <<'PY'
"""Updates every product's price from the supplier."""

from pricesync.client import fetch_price


def sync_all(products: dict[str, float]) -> dict[str, float]:
    return {sku: fetch_price(sku) for sku in products}
PY

cat > tests/test_sync.py <<'PY'
from unittest import mock

from pricesync import sync


def test_sync_all_updates_prices():
    with mock.patch.object(sync, "fetch_price", return_value=2.5):
        assert sync.sync_all({"a": 1.0}) == {"a": 2.5}
PY

git init -q .
git add .
git -c user.name=eval -c user.email=eval@example.invalid commit -q -m "initial"

cat > pricesync/client.py <<'PY'
"""Supplier price API client."""

import json
import time
import urllib.error
import urllib.request

API = "https://supplier.example.com/prices/"


def fetch_price(sku: str) -> float:
    # The supplier API is flaky; keep trying until it answers.
    while True:
        try:
            with urllib.request.urlopen(API + sku, timeout=10) as resp:
                return float(json.load(resp)["price"])
        except (urllib.error.URLError, TimeoutError):
            time.sleep(1)
PY

git add pricesync/client.py
git diff --cached > staged.diff
