---
name: requesting-code-review
description: "Use when completing tasks, implementing major features, or before merging to verify work meets requirements: dispatch a fresh reviewer subagent with the code-reviewer template and act on its findings."
---

> Adapted from obra/superpowers `skills/requesting-code-review` at `2ce8aa1` by Jesse Vincent, MIT License. See NOTICE and UPSTREAM.md.

# Requesting Code Review

Dispatch a code reviewer subagent to catch issues before they cascade. The reviewer gets precisely crafted context
for evaluation, never your session's history.

**Core principle:** Review early, review often.

**Invoking this skill is asking for subagents.** When this skill runs, the owner (or the workflow that called it)
is explicitly asking for the code reviewer subagent. A standing rule to spawn subagents only when the user asks
is met by that request. Dispatch the reviewer; do not review inline instead, and do not ask first.

## When to Request Review

**Mandatory:**
- After each task in `jiance-stack:subagent-driven-development`
- After completing a major feature
- Before merge to main

**Optional but valuable:**
- When stuck (fresh perspective)
- Before refactoring (baseline check)
- After fixing a complex bug

## How to Request

**1. Get git SHAs:**
```bash
BASE_SHA=$(git rev-parse HEAD~1)  # or: git merge-base origin/main HEAD
HEAD_SHA=$(git rev-parse HEAD)
```

**2. Dispatch the code reviewer:**

Use the Agent tool with `subagent_type: general-purpose` and fill the template at
[code-reviewer.md](code-reviewer.md). Set `model` from `config/models.md` (two directories up from this file:
`../../config/models.md`); an omitted model silently inherits the session's model, and `haiku` is never allowed.

| Review | Role in config/models.md |
|---|---|
| One task or a small change | reviewer-b |
| A subtle or risky diff, or a second opinion on a task | reviewer-a |
| The whole branch before merge | final-reviewer |

**Placeholders:**
- `[DESCRIPTION]` - Brief summary of what you built
- `[PLAN_OR_REQUIREMENTS]` - What it should do (the plan task, its "New helpers" list and any approval points)
- `[BASE_SHA]` - Starting commit
- `[HEAD_SHA]` - Ending commit

The reviewer also checks the two jiance-stack gates, so give it what it needs: the plan's list of approved new
helpers, and which steps the plan marked as approval points (a new dependency, a public contract change, a
change touching two or more modules). A new helper that is not on the list and did not pass
`jiance-stack:helper-gate` is an Important finding. An approval point that was passed without the owner's OK is
Critical.

**3. Act on feedback** (with `jiance-stack:receiving-code-review`):
- Fix Critical issues immediately, except security findings: those go to the owner before any fix
- Fix Important issues before proceeding
- Note Minor issues for later
- Push back if the reviewer is wrong (with reasoning)
- Approval points and security findings go to the owner. You do not fix or rule on them yourself.

**4. Verify the fixes** with `jiance-stack:verification-before-completion`: quote the real test output after the
fix pass. A reviewer's "Ready to merge" is not evidence that the tests pass.

## Example

```
[Just completed Task 2: Add verification function]

You: Let me request code review before proceeding.

BASE_SHA=$(git log --oneline | grep "Task 1" | head -1 | cut -d' ' -f1)
HEAD_SHA=$(git rev-parse HEAD)

[Dispatch code reviewer subagent, model from role reviewer-b]
  DESCRIPTION: Added verifyIndex() and repairIndex() with 4 issue types
  PLAN_OR_REQUIREMENTS: Task 2 from docs/plans/deployment-plan.md (New helpers: none)
  BASE_SHA: a7981ec
  HEAD_SHA: 3df7661

[Subagent returns]:
  Strengths: Clean architecture, real tests
  Issues:
    Important: Missing progress indicators
    Minor: Magic number (100) for reporting interval
  Assessment: Ready to proceed

You: [Fix progress indicators, rerun the tests, quote the output]
[Continue to Task 3]
```

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "I'll just review the diff myself instead of dispatching a reviewer" | You're the coordinator: reviewing the diff inline burns the context window you need to keep driving the work. Dispatch a reviewer subagent: the diff and the evaluation live in its context, and only the findings come back to you. |
| "The reviewer needs my whole session history to understand the change" | Hand it precisely crafted context, never your session's history. That keeps the reviewer on the work product, not your thought process. |
| "Use the cheapest model for a quick review" | Reviewer roles come from `config/models.md`. A weak review costs more than it saves. |

## Red Flags

**Never:**
- Skip review because "it's simple"
- Ignore Critical issues
- Proceed with unfixed Important issues
- Argue with valid technical feedback

**If the reviewer is wrong:**
- Push back with technical reasoning
- Show code/tests that prove it works
- Request clarification

See the template at: [code-reviewer.md](code-reviewer.md)
