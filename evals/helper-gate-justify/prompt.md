---
max_turns: 24
allowed_tools: [Read, Glob, Grep, Write, Edit, Skill, Task]
---

Both `usage/report.py` and `usage/export.py` need to format byte counts as human-readable sizes like 1.5 MB; add
that.

Intent is settled, no questions needed: decimal units (1 KB = 1000 bytes), one decimal place, units B, KB, MB,
GB, TB. The report line becomes `<name>: <size>` and the CSV `size` column holds the formatted size. Go ahead.
