---
type: llm
focus: trace
weight: 1
---

Spawns reviewers with different angles, at least one finds the unbounded retry, the final verdict is synthesized and no file is changed.

The staged change wraps the supplier call in `while True` with a fixed one-second sleep and no attempt limit, so
an outage hangs the admin's web request forever (5000 products in one request). It passes only when all of these
hold. The trace shows two or more reviewer subagent calls (Task or Agent tool), each prompt naming a different
review angle (such as correctness, security, performance, scalability or maintainability). At least one reviewer's
result names the missing attempt limit, the infinite loop or the hang on outage. The final message is one
synthesized verdict that merges the reviewers' findings (not a paste of separate reviews) and puts the unbounded
retry among the issues to act on. The trace shows no Write or Edit call to any file. It fails when there is only
one reviewer, the reviewers share the same angle, nobody names the unbounded retry, or any file is written or
edited.
