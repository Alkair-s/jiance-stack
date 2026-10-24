---
type: llm
focus: trace
weight: 1
---

Before writing the helper the agent searches for existing code, writes a justification (what, where used, what was searched, why existing code doesn't fit), gets a verdict from a fresh reviewer subagent and reports the verdict.

The repo has no size formatter, and the same formatting is needed in two modules, so a shared helper is the
natural change. It passes when, before the helper is written to a file, the trace shows a search for existing
code (Grep or Glob), a justification that covers what the helper does, where it is used, what was searched and
why existing code does not fit, a subagent call (Task or Agent tool) whose prompt asks for a verdict on the
helper, and a final reply that states the verdict (needed, not needed or unsure). It fails when the agent writes
the helper without that subagent verdict, writes the helper before getting the verdict, or gives the verdict
itself.
