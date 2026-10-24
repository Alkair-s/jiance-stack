#!/usr/bin/env bash
# Builds a small Python sync tool whose CONTRIBUTING.md sets a commit format
# that is not Conventional Commits: "[module] message". The retry delay change
# described in the prompt is already in the working tree.
set -eu

mkdir -p fetch retry tests

cat > README.md <<'MD'
# feedsync

Pulls RSS feeds and stores new items. Modules: `fetch/` (HTTP download) and `retry/` (backoff policy).
MD

cat > CONTRIBUTING.md <<'MD'
# Contributing

- Commit messages use the form `[module] message`, where module is the top-level folder the change is in
  (`[fetch] handle gzip responses`). Imperative mood, lower case, no trailing period.
- Run `python -m pytest` before committing.
MD

cat > fetch/__init__.py <<'PY'
PY

cat > fetch/http.py <<'PY'
import urllib.request


def download(url: str, timeout: float = 10.0) -> bytes:
    with urllib.request.urlopen(url, timeout=timeout) as resp:
        return resp.read()
PY

cat > retry/__init__.py <<'PY'
PY

cat > retry/backoff.py <<'PY'
DEFAULT_DELAY_SECONDS = 5.0


def delays(attempts: int, base: float = DEFAULT_DELAY_SECONDS) -> list[float]:
    """Delay before each retry: base, 2*base, 4*base, ..."""
    return [base * (2 ** i) for i in range(attempts)]
PY

cat > tests/test_backoff.py <<'PY'
from retry.backoff import delays


def test_delays_double() -> None:
    assert delays(3, base=1.0) == [1.0, 2.0, 4.0]
PY
