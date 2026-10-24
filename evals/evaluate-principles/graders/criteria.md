---
type: llm
focus: trace
weight: 1
---

Reports the drift with a file:line, suggests enforcing it with a check, and changes no file.

It passes only when all of these hold. The final answer says the code breaks the "no print statements" rule and
points at it with a file and line reference (`inventory/stock.py` plus a line number, around line 21). It suggests
enforcing that rule with an automatic check (a lint rule such as ruff's T201 or flake8-print, a CI step, a test or
a script) rather than relying on review. The trace shows no Write or Edit call: the agent changes no file, though
it may offer to make a change if the owner approves. It fails when it edits or creates any file (for example by
replacing the `print` with `log`), gives no line reference for the drift, or suggests no automatic check.
