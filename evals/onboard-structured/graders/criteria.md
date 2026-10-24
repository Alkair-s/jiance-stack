---
type: llm
focus: trace
weight: 1
---

Reports the role map, edits no existing file, and does not offer setup-structure.

It passes only when all of these hold. The final answer maps the project's files to roles: it names
`CLAUDE.md` as the router (or root rules), the files in `docs/contracts/` as the module contracts and
`PROGRESS.md` as the progress log, and says it will follow them as the project's rules (for example it will
update PROGRESS.md in the same commit, read a module's contract before touching it, run `go test ./...`). The
trace shows no Write or Edit call. The answer does not offer to add, restructure or set up the project's
structure (no offer to write a new CLAUDE.md, new contracts or a structure setup), though it may note that a
role such as a decision log has no file and that defaults cover it. It fails when it edits or creates a file,
gives no file-to-role mapping, or offers to set up or add structure.
