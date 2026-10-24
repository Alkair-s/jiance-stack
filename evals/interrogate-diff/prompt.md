---
max_turns: 30
allowed_tools: [Read, Glob, Grep, Write, Edit, Skill, Task]
---

Interrogate my staged change before I commit it: tear it apart and find the blind spots. You have no shell, so I
saved `git diff --cached` in `staged.diff`. Do not change any files; I only want the verdict.
