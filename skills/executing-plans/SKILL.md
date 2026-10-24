---
name: executing-plans
description: Use when executing an implementation plan in the current session as the implementer yourself - your human partner chose inline execution, or no subagent tool is available
---

> Adapted from obra/superpowers `skills/executing-plans` at `2ce8aa1` by Jesse Vincent, MIT License. See NOTICE and UPSTREAM.md.

# Executing Plans

Execute the plan yourself, task by task, in this session: no implementer
subagent per task, no reviewer per task. One fresh-context review of the
whole branch at the end.

**Why inline:** Subagent-driven development pays for a fresh implementer
and a fresh reviewer on every task, each re-reading the codebase from zero.
Inline execution pays for one context (yours) plus one reviewer at the end.
What it gives up is a fresh context per task and a second pair of eyes per
task. This skill keeps what those two things bought, by other means: the
brief is the spec, the ledger is your memory, the testing evidence is the per-task gate, and
the final reviewer is the second pair of eyes.

**Core principle:** The plan already did the thinking. Execute it exactly,
prove each step with a test you watched fail and then pass, and leave a
record that survives your own forgetting.

**Narration:** between tool calls, narrate at most one short line - the
ledger and the tool results carry the record.

**Continuous execution:** Do not pause to check in with your human partner
between tasks. They chose inline execution to spend less, not to answer
"should I continue?" after every task. Execute all tasks from the plan
without stopping.

**Rulings, not stalls.** Conflicts, ambiguities, plan defects - decide them.
The spec is the binding authority, the plan is its argument, and your
judgment settles what neither answers. Record every decision in the ledger
as `Ruling: <what you decided> - <why> - <what it costs if wrong>`, and keep
going. Deviating from the plan without a ledgered ruling is a decision made
in secret.

Five things stop you, and only these: an irreversible or destructive
operation; a security-sensitive action; a side effect outside this worktree
that norms say you ask about first (a merge, a push to a shared branch, a
publish); a plan so broken that every path forward is a guess; and one of the
owner's approval points. For those, stop and ask.

**Approval points are not rulings.** "Rulings, not stalls" never overrides the owner's approval points (the list
is in `jiance-stack:using-jiance`: public contract or invariant changes, two or more modules, new dependencies,
security-review findings, missed performance targets, structure setup, edits to the project's own docs, helpers
the reviewer is unsure about). A task the plan marks "Approval point", or that you find hits one, stops at the
marked step: ask the owner, wait, and ledger their answer as `Approval: <point> - <owner's answer>`. Do not
decide it yourself and do not continue past it. Tasks that do not depend on it may go on while you wait.

**New helpers.** The plan's "New helpers" list per task is the approved set. Any new helper that is NOT in that
list runs `jiance-stack:helper-gate` before it is written (private one-off code inside one function is not
gated), and the verdict goes in the ledger next to the rulings:
`Task <N>: Helper-gate: <helper> - <verdict: not needed | needed | owner OK> - <reused code or reason>`.

Paths in this skill (`scripts/`, `references/`) are relative to its base directory, which the Skill tool shows
when it loads the skill.

## When to Use

- You have a plan from jiance-stack:writing-plans and your human partner
  chose inline execution at the handoff.
- Your harness has no subagent tool (the Agent tool is not available).
  Never fabricate a dispatch; run
  the plan here.
- Tasks are mostly independent - the same precondition as
  jiance-stack:subagent-driven-development.

A fully specified plan makes inline execution transcription plus testing:
it runs well on a mid-tier session model, and the one place the most
capable model earns its cost is the final review, which this skill
dispatches separately. Tell your human partner so when they choose inline.

Prefer jiance-stack:subagent-driven-development when your human partner
wants a review gate on every task, or when the plan is long enough that
its later tasks would run on a compacted context. Inline execution over a
long plan still works - the ledger is what makes it recoverable - but the
last tasks get the least of you.

## The Process

1. Setup: isolated workspace, ledger, read the plan and spec, pre-flight scan.
2. For each task: `task-start`, read the brief, work the steps in order (test first, run every verification, read
   every output), commit as the plan says, check the completion contract, `task-done`.
3. When the output differs from the plan's Expected: code wrong means `jiance-stack:systematic-debugging`; plan
   wrong means a ruling in the ledger.
4. A task that hits an approval point stops for the owner (see below).
5. After the last task: final whole-branch review, one fix pass, then `jiance-stack:finishing-a-development-branch`.

## Setup

Ensure the work happens in an isolated workspace: use
jiance-stack:using-git-worktrees to create one or verify the existing one.
Never start implementation on a main/master branch without your human
partner's explicit consent.

Conversation memory does not survive compaction. An inline executor that
loses its place re-implements tasks whose commits already exist - the same
failure as a controller re-dispatching them, paid for in your own context.
Track progress in a ledger file, not only in todos. Harness todos are a
live view; the ledger is the record.

The workspace and ledger are shared with jiance-stack:subagent-driven-development
- same directory, same format - so a plan can change executors mid-flight
and the new one resumes from the same ledger.

- Each plan owns a workspace: at skill start, run
  `../subagent-driven-development/scripts/sdd-workspace PLAN_FILE` - it
  prints the plan's git-ignored directory
  (`<repo-root>/.jiance-stack/sdd/<plan-basename>/`), home to every
  artifact for THIS plan: ledger, briefs, review packages. Another plan's
  directory is never yours to read or write.
- Check for this plan's ledger at `<workspace>/progress.md`. If its first
  line names your plan file, tasks with a `Task <N>: complete` line are
  DONE - do not redo them; resume at the first task without one. Their
  commits exist in git even when your context no longer remembers making
  them: after compaction, trust the ledger and `git log` over your own
  recollection. A ledger whose first line names a different plan file is
  another plan's progress: leave it and start your own, fresh.
- Create the ledger with its identity as the first line:
  `# SDD ledger - plan: <plan file path>`. Rulings, approvals and helper-gate verdicts go in the same file.
- `git clean -fdx` will destroy the workspace (it's git-ignored scratch);
  if that happens, recover from `git log`.

Read the plan once, note its context and Global Constraints, and create a
todo per task. If the plan names a Spec, read that too: the spec is the
authority the plan argues from, and conflicts inside the plan resolve
against it. A plan with no reachable spec gets a ledger note saying so -
rulings made without one are provisional.

**REQUIRED SUB-SKILL:** load jiance-stack:testing now,
before Task 1. It governs every step of every task below; a plan whose
steps already say "write the failing test first" does not exempt you
from reading it.

Before Task 1, scan the plan for conflicts between tasks. The plan's
Interfaces blocks tell you where to look: for every task that consumes
what an earlier task produces, one ledger row - the two tasks, what one
produces against what the other consumes, and what you found. Tasks that
share nothing get no row; a plan whose tasks share nothing gets the single
line `Pre-flight: no shared interfaces`. Rule on each conflict a row
surfaces with the spec as the binding authority, record the ruling beside
its row, and start Task 1. Each task's own text is checked when you read
its brief, not here.

## The Task Loop

Everything you print, and every tool result, stays resident in your
context for the rest of the session. Redirect long test output to a file
in the workspace and read its tail; read a brief, not the whole plan.

### 1. Take the task

- Run this skill's `scripts/task-start PLAN_FILE N`. It prints the brief
  path and BASE (the commit the task's range is cut from) in one call.
  Read the brief for every task, including ones you remember from setup:
  what you remember is a summary, the brief has the exact values,
  signatures, and test cases.
- Mark the task's todo in_progress.

Every tool call is a turn that re-reads your whole context. Bookkeeping
rides along with work - a ledger append in the same call as the commit,
never in a call of its own.

### 2. Work the steps

The plan's steps are already in failing-before / passing-after order; follow them in that
order under jiance-stack:testing, loaded at setup. A test
step's code is written first and run first. Watching it fail is a step,
not a formality - a test that passes before the implementation exists is
a finding about the test. A task the plan gives a substitute instead of a test
keeps the substitute's written reason in the project's docs as the plan says.
Before a step creates a helper, check it against the task's "New helpers" list
(see above).

Every step that runs a command has an `Expected:` line. Run the command,
read its output, and compare. Three outcomes:

- **Matches.** Next step.
- **The code is wrong.** Use jiance-stack:systematic-debugging. Find the
  cause; never patch the symptom to make the step's output match.
- **The plan is wrong** - a step contradicts the spec, an interface from an
  earlier task doesn't match what this task consumes, a command that
  cannot work. Rule on the smallest change that satisfies the spec, ledger
  it as `Task <N>: Ruling: <finding> - <what you decided and why>`, and
  continue. The ruling is carried, not remembered: later tasks that touch
  the same interface read it from the ledger.

Commit as the plan's commit steps say. A task that spans several commits
is fine; BASE is what the review range is cut from, never `HEAD~1`.

### 3. The completion contract

Before a task's ledger line, all of the following are true, with evidence
in this session - not inferred from the diff looking right:

- Every test the brief names exists and ran in this task, and you read
  the output.
- The final test run for the task passed - `task-done` is that run, and
  it writes the command and result into the ledger line.
- Every `Expected:` line in the brief was compared against real output.
- Every deviation from the brief has a `Ruling:` line in the ledger.
- Every new helper is in the task's "New helpers" list or has a `Helper-gate:` line in the ledger.
- Every approval point the task hit has an `Approval:` line with the owner's answer.
- Every test has its failing-before and passing-after run (or its substitute with the written reason), per the
  testing evidence report.

**REQUIRED SUB-SKILL:** jiance-stack:verification-before-completion governs
the claim. If any item is missing, the task is not complete: finish it.

### 4. Complete the task

Run this skill's `scripts/task-done PLAN_FILE N BASE -- <test command>`
with the test command the brief names for the whole task. It runs the
tests, keeps the full output in the workspace, prints the tail, and - only
if they pass - appends the completion line to the ledger:

`Task <N>: complete (commits <base7>..<head7>, tests: <command> -> <result>)`

A failing run records nothing; the task is not complete. When it records,
mark the todo complete and take the next task.

## Final Review and Finish

When every task is complete, read [references/final-review.md](references/final-review.md) and follow it. It
covers the whole-branch review (role `final-reviewer`), the single fix pass, the "Rulings I made" list and how
you finish.

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "I remember what Task N says" | You remember a summary. The brief has the exact values. Read it. |
| "The plan's code is right, skip watching the test fail" | A test you never saw fail proves nothing. It is one step. Run it. |
| "I'll run the full suite at the end instead of per step" | Per-step runs are how you learn which step broke it. The end-of-task run is the contract, not a substitute. |
| "The plan is wrong here, I'll just do the right thing" | Do the right thing and ledger the ruling. Unledgered deviation is a decision made in secret. |
| "I'll write the ledger lines after a few tasks" | Compaction does not wait for a convenient moment. One line per task, in the same message as the commit. |
| "Let me check in before the next task" | They chose inline to spend less. Progress prompts spend their time instead. Only the five stops stop you. |
| "I read my own diff carefully; the final reviewer is redundant" | Same author, same blind spots. The reviewer is the only fresh context this run buys. |
| "Tests should pass, the change was trivial" | "Should" is not evidence. The contract requires the command and its output. |
| "Subagents are slow and expensive, I'll skip the final review too" | Inline already removed the per-task reviewers. One review of the whole branch is the floor, not the ceiling. |
| "The reviewer said Minor, so it's Minor" | The label graded the spec's silence. Grade what the person gets. Re-grade, then gate. |
| "The fix is obvious, no need for a failing test first" | The failing test is the only proof the finding was real and is now gone. Without it you have a diff and a hope. |
| "I'll fix the minors too while I'm in there" | Every minor you fix is a test, a fix, and a suite run your partner did not ask for. Ledger them; your partner decides. |
| "The spec/plan already names the dependency, so I can add it" | A new dependency is an approval point. Stop at the marked step and wait for the owner. |
| "This helper is small, I will skip the gate" | Not listed in the plan means the gate runs first, and the verdict goes in the ledger. |
