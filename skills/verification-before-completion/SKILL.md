---
name: verification-before-completion
description: "Use before you tell the owner that work is complete, fixed or passing, and before committing or opening a PR: run the verification command and quote its real output; if you cannot run it (no shell, no hardware), say so and do not claim success. Load this before writing any final \"done\" message."
---

> Adapted from obra/superpowers `skills/verification-before-completion` at `2ce8aa1` by Jesse Vincent, MIT License. See NOTICE and UPSTREAM.md.

# Verification Before Completion

## Overview

**Core principle:** Evidence before claims, always. This is principle P4 (principles/defaults.md): report real
command output, never claims or assumptions. The owner can only trust a result that is backed by output they can
see.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE, QUOTED IN THE MESSAGE
```

If you haven't run the verification command in this message, you cannot claim it passes. If you ran it but did
not quote the output, the owner cannot see the evidence: quote the relevant lines (the summary line and any
failures), not a paraphrase.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH the quoted output
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## When the Command Cannot Be Run

Sometimes the proof is out of reach: no shell tool in this session, the test needs hardware or a service you
cannot start, the environment is missing a dependency. Then there is no success claim to make. Do this instead:

1. Say plainly that you could not run it, and why, in the same message as your result.
2. Describe what you changed and what you expect, labelled as expectation: "I changed the divisor to
   `len(values)`; I could not run the tests, so this is unverified. Please run `python -m pytest`."
3. Give the exact command that will prove or disprove it, so the owner (or the next session) can run it.
4. Do not write "fixed", "done", "passes" or "should work now" anywhere in that message.

A **recorded substitute** may stand in for the command only with its written reason: name the substitute (a
different command, a manual check, a code read), say why the real command could not run, and say what the
substitute does and does not prove. A substitute without that written reason is a claim without evidence. This is
the same rule `jiance-stack:testing` applies to a test that is skipped on purpose.

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test command output: 0 failures, quoted | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified (see `jiance-stack:testing`) | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Tests passing |
| Could not run the command | A plain statement that it was not run, with the command to run | Any success wording |

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!", etc.)
- About to commit/push/PR without verification
- Trusting agent success reports
- Relying on partial verification
- Thinking "just this once"
- Tired and wanting work over
- Unable to run the command and about to say "fixed" anyway
- **ANY wording implying success without having run verification**

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification, or say you could not |
| "I'm confident" | Confidence is not evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter is not the compiler |
| "Agent said success" | Verify independently |
| "I'm tired" | Exhaustion is not an excuse |
| "Partial check is enough" | Partial proves nothing |
| "I can't run it, but the change is obviously right" | Then say you could not run it. "Obviously right" is a claim, not output |
| "Different words so rule doesn't apply" | Spirit over letter |

## Key Patterns

**Tests:**
```
GOOD: [Run test command] [Quote: 34 passed in 0.8s] "All tests pass"
BAD:  "Should pass now" / "Looks correct"
```

**Cannot run:**
```
GOOD: "Changed the divisor. I could not run the tests here (no shell). Unverified; run: python -m pytest"
BAD:  "Fixed! The tests should pass now."
```

**Regression tests (red-green):**
```
GOOD: Write -> Run (pass) -> Revert fix -> Run (MUST FAIL) -> Restore -> Run (pass)
BAD:  "I've written a regression test" (without red-green verification)
```

**Build:**
```
GOOD: [Run build] [See: exit 0] "Build passes"
BAD:  "Linter passed" (linter doesn't check compilation)
```

**Requirements:**
```
GOOD: Re-read plan -> Create checklist -> Verify each -> Report gaps or completion
BAD:  "Tests pass, phase complete"
```

**Agent delegation:**
```
GOOD: Agent reports success -> Check VCS diff -> Verify changes -> Report actual state
BAD:  Trust agent report
```

## When To Apply

**ALWAYS before:**
- ANY variation of success/completion claims
- ANY expression of satisfaction
- ANY positive statement about work state
- Committing, PR creation, task completion
- Moving to next task
- Delegating to agents
- Choosing an option in `jiance-stack:finishing-a-development-branch`

**Rule applies to:**
- Exact phrases
- Paraphrases and synonyms
- Implications of success
- ANY communication suggesting completion/correctness

## Related

- `jiance-stack:testing`: the failing-before / passing-after evidence a bug fix needs.
- `jiance-stack:systematic-debugging`: find the cause before the fix you are about to verify.
