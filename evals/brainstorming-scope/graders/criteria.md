---
type: llm
focus: trace
weight: 1
---

Asks one question about intent before proposing an implementation; no code written.

It passes when the agent's reply asks a single question about what the person wants or why (for example which
date, what the photos are, what they want to end up with) and does not propose a design, a language or a
library yet, and no code file was written. It fails when it writes code or creates files for the tool, lists an
implementation plan before asking, or asks several questions at once.
