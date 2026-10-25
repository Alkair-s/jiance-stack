# Final Review and Finish (inline execution)

> Adapted from obra/superpowers `skills/executing-plans/SKILL.md` at `2ce8aa1` by Jesse Vincent, MIT License. See NOTICE and UPSTREAM.md.

Part of jiance-stack:executing-plans. Every task has a ledger completion line.
Paths: all relative paths in this file are relative to this file (`skills/executing-plans/references`).

Run `../../subagent-driven-development/scripts/review-package PLAN_FILE MERGE_BASE HEAD`
(MERGE_BASE = the commit the branch started from, e.g.
`git merge-base main HEAD`) and review from the file it prints.

**Invoking this skill is asking for subagents.** Choosing inline execution at the plan handoff still asks for
the final-reviewer subagent below. A standing rule to spawn subagents only when the user asks is met by that
request. Dispatch it when the Agent tool is available; do not replace it with your own read and do not ask first.

**With a subagent tool:** dispatch the reviewer with the Agent tool (`subagent_type: general-purpose`) on the
`final-reviewer` role of `../../../config/models.md` (a project's `CLAUDE.md` `## Models` section overrides it) -
the whole-branch review is a judgment task. Use the review prompt of
jiance-stack:requesting-code-review (`code-reviewer.md` in that skill's directory; if that skill is not
available, use `../../subagent-driven-development/task-reviewer-prompt.md` aimed at the whole branch), with the
package path, the plan and spec paths, the plan's Review Focus section
verbatim if it has one (the input classes and failure modes the plan's
tests do not exercise - the reviewer checks each deliberately), and a
pointer to the ledger's `Ruling:`, `Approval:` and `Helper-gate:` lines so it can weigh the calls you
made. Ask it to flag any new helper that is neither in the plan's "New helpers" lists nor ledgered with a
helper-gate verdict (Important), and any approval point the plan marks that has no `Approval:` line (Critical).
Specify the model
explicitly; an omitted model inherits the session's, which may not be the
most capable. This is the one fresh context the whole run buys. Do not
skip it, and do not replace it with your own read of the diff.

**Without a subagent tool:** read code-reviewer.md and perform that review
yourself against the package, as a separate pass after the last task's
ledger line. Write `Final review: self-review (no subagent tool)` to the
ledger, and say so in your final message: a self-review by the author is
weaker than a fresh reviewer, and your human partner decides whether that
is enough before merge.

Sort the findings before you act on any of them. The reviewer's severity
labels are advice; the gate is yours. Its "Declined to judge" list is
yours too: every line there is a ruling you make and ledger, exactly like
a plan conflict - `Final: Ruling: <behavior the reviewer set aside> -
<what a reasonable person using this software gets, and why that stands
or why it is now a finding> - <cost if wrong>`. Re-grade first, by effect: the
spec is a vision document, and a finding's grade is what a reasonable
person using this software gets if it ships, not whether the spec names
the input that triggers it - a reviewer who set a finding at Minor
because the spec was silent has graded the spec, not the effect. Then:

- **Critical and Important** enter the fix pass.
- **Minor** goes to the ledger as `Final: minor (deferred): <one-liner>`
  and to your final message under "Deferred minors". Minors never enter
  the fix pass, and never become rulings - a ruling is a decision about a
  conflict, not a note that you declined a polish suggestion.

Fix the Critical and Important findings yourself - you are the
implementer here - in ONE pass. Each fix is verified by tests, not by a second reviewer, and follows
`jiance-stack:testing`: a behaviour fix gets its failing-before test (write it, watch it fail, make it pass) or a
recorded substitute with its written reason, never a bad test; a fix with no behaviour change (docs, a refactor)
needs only the existing suite green. Then run the whole suite. Record each in the ledger as
`Final: fixed <finding> - <test name> RED->GREEN | <substitute> | no behaviour change, suite <N>/<N>`. A suite
that is not green after the pass means the pass is not over. Do not dispatch a
re-review: it would re-read a diff whose covering tests already answer
"addressed" and whose suite run already answers "broke nothing".

A finding you decide not to fix is a ruling - `Final: Ruling: <finding> -
<why the code stands> - <cost if wrong>` - and reaches your human partner
in the rulings list. There is no second fix pass.

**Approval points stay out of the fix pass.** A finding that a task passed an approval point without the owner's
OK, and every security finding, is never fixed or ruled by you: it goes to the owner before any fix. Ledger
`Approval: <point> - asked`, put it first in your final message and wait for the owner (see "Not for the breaker"
in ../../subagent-driven-development/references/fix-loop.md). An unlisted, ungated helper goes back through
`jiance-stack:helper-gate` before the fix pass.

## Finish

Before you delete anything, collect every ledger line containing
`Ruling:` into your final message under "Rulings I made" (with the `Helper-gate:` and `Approval:` lines, each under its own heading), in the order you
made them, each with what it costs if wrong, and every `minor (deferred)`
line under "Deferred minors". Both lists are exhaustive. Your final
message is the only place the decisions you took on your human partner's
behalf - and the findings you chose not to act on - reach them.

When the final review is clean and its fixes are committed, delete this
plan's workspace directory - the git history is the record now. Sibling
directories belong to other plans; leave them alone.

Use jiance-stack:finishing-a-development-branch.

