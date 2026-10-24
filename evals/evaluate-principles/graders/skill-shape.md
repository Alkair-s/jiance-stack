---
type: llm
focus: last_message
weight: 1
---

Gives a per-rule table and a ranked suggestion list, and flags that the rules carry no reason.

It passes only when all of these hold. The answer has a table with one row per CONTRIBUTING.md rule (three rows),
and the table or its rows say what each rule protects (its purpose), where the code follows or drifts from it,
and what could be stronger. After the table comes a numbered suggestion list ordered by importance (the answer
says it is ranked, or puts the most important item first and says so). The answer points out that the rules
are written without a reason (no "why" next to each rule) and suggests adding one. It fails when there is no
table, when the table lacks the purpose of each rule, when the suggestions are not a ranked list, or when the
missing reasons are not mentioned.
