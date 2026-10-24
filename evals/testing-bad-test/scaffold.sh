#!/usr/bin/env bash
# Builds a tiny static web page in the eval workspace (the current directory):
# a theme stylesheet, one page, a Python test for the form logic and a manual
# test checklist.
set -eu

mkdir -p ui tests docs

cat > README.md <<'MD'
# signup-page

A static signup page. Logic tests: python -m pytest. Visual checks: docs/test-checklist.md.
MD

cat > ui/theme.css <<'CSS'
:root {
  --text: #1F2328;
  --background: #FFFFFF;
}

.button {
  background-color: #2F81F7;
  color: #FFFFFF;
  border-radius: 6px;
  padding: 8px 16px;
}
CSS

cat > ui/index.html <<'HTML'
<!doctype html>
<html lang="en">
<head><meta charset="utf-8"><link rel="stylesheet" href="theme.css"><title>Sign up</title></head>
<body>
  <form id="signup"><input name="email" type="email"><button class="button" type="submit">Sign up</button></form>
</body>
</html>
HTML

cat > ui/validate.py <<'PY'
def is_valid_email(text: str) -> bool:
    """Accept a single address with one @ and a dot in the domain."""
    local, sep, domain = text.strip().partition("@")
    return bool(local) and sep == "@" and "." in domain and "@" not in domain
PY

cat > tests/test_validate.py <<'PY'
from ui.validate import is_valid_email


def test_accepts_plain_address():
    assert is_valid_email("a@example.com")


def test_rejects_missing_at():
    assert not is_valid_email("a.example.com")
PY

cat > docs/test-checklist.md <<'MD'
# Test checklist

Manual checks for things automated tests do not cover. Each item says what to check and why it is manual.

- [ ] Signup page loads with no console errors in a current browser. Why manual: no browser test harness.
MD
