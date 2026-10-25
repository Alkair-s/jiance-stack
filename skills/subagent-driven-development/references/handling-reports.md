# Handling a Report That Isn't DONE

> Adapted from obra/superpowers `skills/subagent-driven-development/references/handling-reports.md` at `2ce8aa1` by Jesse Vincent, MIT License. See NOTICE and UPSTREAM.md.

Paths: links and `../` paths are relative to this file; `bash scripts/...` runs from the skill base directory.
Part of jiance-stack:subagent-driven-development.

**DONE_WITH_CONCERNS:** The implementer completed the work but flagged doubts. Read the concerns before proceeding. If the concerns are about correctness or scope, address them before review. If they're observations (e.g., "this file is getting large"), note them and proceed to review.

**NEEDS_CONTEXT:** The implementer needs information that wasn't provided. Provide the missing context and re-dispatch.

**BLOCKED:** The implementer cannot complete the task. Assess the blocker:
1. If it's a context problem, provide more context and re-dispatch with the same model
2. If the task requires more reasoning, re-dispatch with the `reviewer-a` model (opus)
3. If the task is too large, break it into smaller pieces
4. If the plan itself is wrong, rule on the correction, ledger it, and re-dispatch with the ruling carried in the dispatch

**Never** ignore an escalation or force the same model to retry without changes. If the implementer said it's stuck, something needs to change.

**NEEDS_CONTEXT at an approval point:** if the implementer stopped because the task hit one of the owner's
approval points, do not answer it yourself. Ask the owner, wait, ledger `Approval: <point> - <answer>`, then
re-dispatch with the answer in the dispatch.

**NEEDS_CONTEXT because the implementer has no Agent tool for the helper gate:** run `jiance-stack:helper-gate`
yourself for that helper (reviewer model: the `helper-gate-reviewer` role of `../../../config/models.md`), ledger
`Task <N>: Helper-gate: <helper> - <verdict> - <reason>`, then re-dispatch with the verdict in the dispatch.
