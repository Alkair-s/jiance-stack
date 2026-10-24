#!/usr/bin/env bash
# Builds a tiny Python blog package in the eval workspace (the current directory):
# an existing slugify helper in utils/strings.py, used by the site module, and a
# new, almost empty export module.
set -eu

mkdir -p blog/utils blog/site blog/export tests

cat > README.md <<'MD'
# blog

A small static blog generator. Run the tests with: python -m pytest
MD

cat > pyproject.toml <<'TOML'
[project]
name = "blog"
version = "0.1.0"
requires-python = ">=3.10"

[tool.pytest.ini_options]
testpaths = ["tests"]
TOML

cat > blog/__init__.py <<'PY'
PY

cat > blog/utils/__init__.py <<'PY'
PY

cat > blog/utils/strings.py <<'PY'
"""Small string helpers shared by the site and other modules."""

import re
import unicodedata


def slugify(text: str) -> str:
    """Return a lowercase URL slug: 'Hello, World!' -> 'hello-world'."""
    normalized = unicodedata.normalize("NFKD", text).encode("ascii", "ignore").decode("ascii")
    words = re.findall(r"[a-z0-9]+", normalized.lower())
    return "-".join(words)


def truncate(text: str, limit: int) -> str:
    """Cut text to limit characters, adding '...' when it was cut."""
    if len(text) <= limit:
        return text
    return text[: max(limit - 3, 0)] + "..."
PY

cat > blog/site/__init__.py <<'PY'
PY

cat > blog/site/pages.py <<'PY'
"""Builds the HTML page list for the site."""

from blog.utils.strings import slugify


def page_path(title: str) -> str:
    return f"/posts/{slugify(title)}/"
PY

cat > blog/export/__init__.py <<'PY'
"""Export module (new): writes articles to a JSON feed for other sites."""
PY

cat > blog/export/feed.py <<'PY'
"""Builds the JSON export feed. Each entry needs a URL slug made from the title."""

import json


def build_feed(articles: list[dict]) -> str:
    entries = []
    for article in articles:
        entries.append({"title": article["title"], "body": article["body"]})
    return json.dumps({"entries": entries}, indent=2)
PY

cat > tests/test_strings.py <<'PY'
from blog.utils.strings import slugify


def test_slugify_basic():
    assert slugify("Hello, World!") == "hello-world"
PY
