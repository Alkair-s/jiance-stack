---
type: llm
focus: trace
weight: 1
---

The plan's test steps show a failing run before code, lists the new helpers it introduces, and flags the step that adds a dependency as needing the owner's approval.

Read the plan file the agent wrote (a markdown file under docs/ or wherever the project says). It passes only when all three hold: (1) the test steps put a test before the code and include a run with the command and the expected failure (a failing run before any production code); (2) each task lists its new helpers, or says "none"; the plan names the helpers it introduces (for example a CSV row-formatting or escaping function) in a clear list; (3) the task or step that adds a dependency (the spec asks for a CSV library) is explicitly marked as needing the owner's approval before it is done. It fails if any of the three is missing.
