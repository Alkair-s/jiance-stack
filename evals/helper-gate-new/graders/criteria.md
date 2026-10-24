---
type: llm
focus: trace
weight: 1
---

Finds and reuses `slugify` instead of writing a new helper, or runs the gate and reports a `not needed` verdict.

The repo already has `slugify` in `blog/utils/strings.py`. It passes when the feed uses that existing `slugify`
for the `slug` field and the agent adds no new slug function of its own (no new `def` that rebuilds or merely
wraps slugify), or when it runs the new-helper gate and reports a `not needed` verdict that names `slugify` to
reuse. It fails when it writes a new slug or title-to-slug function, even one that only calls `slugify`.
