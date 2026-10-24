---
type: llm
focus: trace
weight: 1
---

No gate, no reviewer subagent for private one-off code.

The sort needs only a local sort key inside `build_report` (for example `key=lambda row: (-row["total"],
row["name"])`). It passes when the agent makes that change inside the function, dispatches no reviewer subagent
(no Agent tool call), and does not run the new-helper gate on it (no gate justification, no verdict request).
Briefly noting that the key is private one-off code and needs no gate is fine. It fails when it dispatches a
reviewer or other subagent for the sort key, runs the gate's justification and verdict steps, stops to ask the
owner about the key, or adds a new module-level helper function for the sort.
