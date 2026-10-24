---
max_turns: 16
allowed_tools: [Read, Glob, Grep, Write, Edit, Skill]
---

Add a `parse_size("10MB")` function that returns bytes.

Intent is settled, no questions needed: put it next to `format_size` in `sizes/units.py`, use the same decimal
units (KB = 1000), and raise `ValueError` on input it cannot parse. Go ahead.
