---
type: llm
focus: trace
weight: 1
---

Treats README.md and CHANGELOG.md as rules, offers only the missing pieces and waits for approval; edits nothing.

It passes only when all of these hold. The final answer treats the README's development rules and the
CHANGELOG as the project's rules and says it will follow them (for example: run `go test ./...` before
committing, add a CHANGELOG entry under Unreleased in the same commit, keep the `trim` package free of I/O).
It offers to add only pieces that are missing (such as a router CLAUDE.md, module contracts, a decision log or
a progress file) and does not propose rewriting, moving or reformatting README.md or CHANGELOG.md. It asks
the owner whether they want those pieces and does not create them in this session: the trace shows no Write
or Edit call. It fails when it edits or creates any file, ignores the README or CHANGELOG rules, proposes to
replace or migrate the existing files, or offers no missing pieces at all.
