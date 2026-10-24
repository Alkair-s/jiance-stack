---
type: llm
focus: trace
weight: 1
---

Offers to set up the project structure and writes nothing before approval.

It passes only when all of these hold. The final answer says the project has no written rules or structure
(no CLAUDE.md, contracts, decision log or progress file) and offers to set one up: at least a root CLAUDE.md
that routes to per-module docs or contracts, and some of a decision log, a progress file or contracts that
describe what the code does today. It asks the owner to approve before anything is written. The trace shows no
Write or Edit call: no file is created or changed in this session. It fails when it creates or edits any file,
or when it does not offer the structure.
