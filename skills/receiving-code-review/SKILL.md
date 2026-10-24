---
name: receiving-code-review
description: "Use when receiving code review feedback, before implementing suggestions, especially if feedback seems unclear or technically questionable: verify each item against the code, push back with reasons, send helper suggestions through the helper gate; no performative agreement."
---

> Adapted from obra/superpowers `skills/receiving-code-review` at `2ce8aa1` by Jesse Vincent, MIT License. See NOTICE and UPSTREAM.md.

# Code Review Reception

## Overview

Code review requires technical evaluation, not emotional performance.

**Core principle:** Verify before implementing. Ask before assuming. Technical correctness over social comfort.

## The Response Pattern

```
WHEN receiving code review feedback:

1. READ: Complete feedback without reacting
2. UNDERSTAND: Restate requirement in own words (or ask)
3. VERIFY: Check against codebase reality
4. EVALUATE: Technically sound for THIS codebase?
5. RESPOND: Technical acknowledgment or reasoned pushback
6. IMPLEMENT: One item at a time, test each
```

## Forbidden Responses

**NEVER:**
- "You're absolutely right!" (performative, and it skips the verification)
- "Great point!" / "Excellent feedback!" (performative)
- "Let me implement that now" (before verification)

**INSTEAD:**
- Restate the technical requirement
- Ask clarifying questions
- Push back with technical reasoning if wrong
- Just start working (actions > words)

## Handling Unclear Feedback

```
IF any item is unclear:
  STOP - do not implement anything yet
  ASK for clarification on unclear items

WHY: Items may be related. Partial understanding = wrong implementation.
```

**Example:**
```
the owner: "Fix 1-6"
You understand 1,2,3,6. Unclear on 4,5.

BAD: WRONG: Implement 1,2,3,6 now, ask about 4,5 later
GOOD: RIGHT: "I understand items 1,2,3,6. Need clarification on 4 and 5 before proceeding."
```

## Source-Specific Handling

### From the owner
- **Trusted** - implement after understanding
- **Still ask** if scope unclear
- **No performative agreement**
- **Skip to action** or technical acknowledgment

### From External Reviewers
```
BEFORE implementing:
  1. Check: Technically correct for THIS codebase?
  2. Check: Breaks existing functionality?
  3. Check: Reason for current implementation?
  4. Check: Works on all platforms/versions?
  5. Check: Does reviewer understand full context?

IF suggestion seems wrong:
  Push back with technical reasoning

IF can't easily verify:
  Say so: "I can't verify this without [X]. Should I [investigate/ask/proceed]?"

IF conflicts with the owner's prior decisions:
  Stop and discuss with the owner first
```

**The owner's rule:** "External feedback - be skeptical, but check carefully"

## YAGNI Check for "Professional" Features

```
IF reviewer suggests "implementing properly":
  grep codebase for actual usage

  IF unused: "This endpoint isn't called. Remove it (YAGNI)?"
  IF used: Then implement properly
```

**The owner's rule:** "You and reviewer both report to me. If we don't need this feature, don't add it."

## "Extract a Helper" Suggestions

A reviewer often says "extract this into a helper", "add a utility for this" or "wrap this call". That is a new
helper, so it goes through `jiance-stack:helper-gate` before any code is written: search for existing code,
write the justification, get a fresh reviewer's verdict (or the owner's answer), and log it. A reviewer's
suggestion is not the owner's approval of the helper, and "implement all the feedback" does not approve it either.
Only a plan the owner approved that names the helper, or the owner's direct answer about this specific helper,
replaces the gate. Private one-off code that stays inside a single function is not gated.

The same holds for feedback that would add a dependency, change a public contract or change the architecture:
those are the owner's approval points. Report the suggestion to the owner and wait; do not implement it on the
reviewer's say-so.

## After Implementing

Run the project's tests after each fix and again after the last one, and quote the real output when you report
(`jiance-stack:verification-before-completion`). "Addressed all comments" without output is a claim, not a result.

## Implementation Order

```
FOR multi-item feedback:
  1. Clarify anything unclear FIRST
  2. Then implement in this order:
     - Blocking issues (breaks, security)
     - Simple fixes (typos, imports)
     - Complex fixes (refactoring, logic)
  3. Test each fix individually
  4. Verify no regressions
```

## When To Push Back

Push back when:
- Suggestion breaks existing functionality
- Reviewer lacks full context
- Violates YAGNI (unused feature)
- Technically incorrect for this stack
- Legacy/compatibility reasons exist
- Conflicts with the owner's architectural decisions

**How to push back:**
- Use technical reasoning, not defensiveness
- Ask specific questions
- Reference working tests/code
- Involve the owner if architectural

**If you're uncomfortable pushing back out loud:** Name that tension, then tell the owner about the issue you've seen. They will appreciate your honesty.

## Acknowledging Correct Feedback

When feedback IS correct:
```
GOOD: "Fixed. [Brief description of what changed]"
GOOD: "Good catch - [specific issue]. Fixed in [location]."
GOOD: [Just fix it and show in the code]

BAD: "You're absolutely right!"
BAD: "Great point!"
BAD: "Thanks for catching that!"
BAD: "Thanks for [anything]"
BAD: ANY gratitude expression
```

**Why no thanks:** Actions speak. Just fix it. The code itself shows you heard the feedback.

**If you catch yourself about to write "Thanks":** DELETE IT. State the fix instead.

## Gracefully Correcting Your Pushback

If you pushed back and were wrong:
```
GOOD: "You were right - I checked [X] and it does [Y]. Implementing now."
GOOD: "Verified this and you're correct. My initial understanding was wrong because [reason]. Fixing."

BAD: Long apology
BAD: Defending why you pushed back
BAD: Over-explaining
```

State the correction factually and move on.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Performative agreement | State requirement or just act |
| Blind implementation | Verify against codebase first |
| Batch without testing | One at a time, test each |
| Assuming reviewer is right | Check if breaks things |
| Avoiding pushback | Technical correctness > comfort |
| Partial implementation | Clarify all items first |
| Can't verify, proceed anyway | State limitation, ask for direction |

## Real Examples

**Performative Agreement (Bad):**
```
Reviewer: "Remove legacy code"
BAD: "You're absolutely right! Let me remove that..."
```

**Technical Verification (Good):**
```
Reviewer: "Remove legacy code"
GOOD: "Checking... build target is 10.15+, this API needs 13+. Need legacy for backward compat. Current impl has wrong bundle ID - fix it or drop pre-13 support?"
```

**YAGNI (Good):**
```
Reviewer: "Implement proper metrics tracking with database, date filters, CSV export"
GOOD: "Grepped codebase - nothing calls this endpoint. Remove it (YAGNI)? Or is there usage I'm missing?"
```

**Unclear Item (Good):**
```
the owner: "Fix items 1-6"
You understand 1,2,3,6. Unclear on 4,5.
GOOD: "Understand 1,2,3,6. Need clarification on 4 and 5 before implementing."
```

## GitHub Thread Replies

When replying to inline review comments on GitHub, reply in the comment thread (`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies`), not as a top-level PR comment.
