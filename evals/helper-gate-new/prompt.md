---
max_turns: 16
allowed_tools: [Read, Glob, Grep, Write, Edit, Skill, Task]
---

Add a function that turns article titles into URL slugs for the new export module.

Intent is settled, no questions needed: each feed entry in `blog/export/feed.py` gets a `slug` field made from
its title. Go ahead.
