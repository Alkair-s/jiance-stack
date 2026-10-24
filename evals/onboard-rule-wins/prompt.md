---
max_turns: 12
allowed_tools: [Read, Glob, Grep, Write, Edit, Skill]
---

I changed the default retry delay in `retry/backoff.py` from 2 to 5 seconds because the feed servers were
rate-limiting us. The change is already made and the tests pass. Write me the commit message for it.
