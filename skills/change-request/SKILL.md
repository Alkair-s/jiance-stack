---
name: change-request
description: "Use for a fix, a feature or new tests on an existing project: understand, brainstorm, plan, implement with the testing rule and helper gate, check blast radius, review, verify and update the project's own progress files as its rules require."
---

# Change request

The workflow for every fix, feature, behaviour tweak or new test on an existing project. It is a process skill:
each step names the skill that does the work. Run the steps in order, sized to the change (see "Size the
change"), and never skip the testing step, the helper gate or the final verification.

**Core principle:** the project's rules first, a test before the change, proof before the claim.

**Invoking this skill is asking for subagents.** When the owner asks for a change and this workflow runs, the
owner is explicitly asking for the reviewer subagents its steps use: the fresh reviewer of the helper gate
(step 5), the code reviewer (step 7) and the `interrogate` reviewers. A standing rule to spawn subagents only
when the user asks is met by that request. Spawn them with the Agent tool; do not do their job inline and do not
ask first. If the Agent tool is not available, say so where the step needs it.

## Size the change

Decide the size first and say it in one line ("Size: small, one module, no contract change").

| Size | What it is | Steps you skip |
|---|---|---|
| **Tiny** | A one-line typo fix, or one value the owner fully specified (a colour, a default, a message text) | Planning and `interrogate`. Brainstorm is one sentence. Blast radius is one search for other uses. |
| **Small** | A bug fix or small change inside one module, no contract change | `interrogate`, unless the change is risky or contested. The plan is a few lines in your reply. |
| **Gated** | Touches a public contract or invariant, or two or more modules, or adds a dependency | Nothing. Every approval point below applies. |

A **module** is what the project calls one: a folder with its own contract or `CLAUDE.md`, or a package listed
in the router. With no such docs, a top-level package or folder is one module; two files in the same package are
one module.

Size never skips step 1, the testing rule (step 6), the helper gate (step 5) or verification (step 9).
A change with no behaviour change (a refactor, rename or config change) needs no new test, only the existing
suite green, run and quoted (`jiance-stack:testing`); in the step 9 report, "Order" is then "n/a".

## Approval points: stop and wait

The approval points of `jiance-stack:using-jiance` hold at every step: public contract or invariant changes;
changes touching two or more modules (present the plan first); new dependencies; any edit to the project's own
docs or principles that its rules do not already ask for; new helpers when the reviewer is unsure or the project
says "always ask". At one of them, show what you would do, stop, and wait for the owner's explicit OK. A general
"go ahead" on the task does not approve a contract change, a second module or a helper.

## The steps

### 1. Onboard

If this session has not produced a role map for this project, load `jiance-stack:onboard-project` with the
Skill tool and run it now. From then on, the role map's files are the project's rules: commit format, test
command, progress and changelog rules, test checklist.

If onboarding ends with an offer of structure (partial or unstructured project), do not stop the change request
to wait for the answer and do not write any offered file: carry on with the change and put the offer, once, at
the end of your final reply.

### 2. Understand

Read the code the change touches and the contract or docs that describe it, before you reason about it.

- Unfamiliar subsystem, or more than one module: `jiance-stack:how`. When the reason for the current shape
  matters (it looks wrong on purpose, or a decision log mentions it): `jiance-stack:why`.
- A bug whose cause is not plain from reading the code: `jiance-stack:systematic-debugging` finds the root cause
  first. A plain cause (the line that crashes, and why) is enough for a tiny or small fix.
- Write down the current behaviour, the intended behaviour and one small example (an input and the output it
  should give).

### 3. Brainstorm, sized to the work

Anything that creates or changes behaviour gets this step first, sized to the work:

- **Intent settled** by the request, the contract or the docs (the contract says decimals are accepted, the owner
  named the colour): state the intended behaviour in one sentence and go on. No questions.
- **Intent open** on something that changes what you build (an edge case, a default, who it is for): ask the
  owner the one question that matters most, and stop until they answer.
- **New feature or new behaviour** beyond a small fix: load `jiance-stack:brainstorming` and follow it.

### 4. Plan

- **Tiny:** no plan.
- **Small:** a short plan in your reply: files to change, the test to write, any new helper. No approval wait
  unless an approval point applies.
- **Gated:** load `jiance-stack:writing-plans`, write the plan, present it and stop for the owner's approval.
  Execute it later with `jiance-stack:executing-plans` or `jiance-stack:subagent-driven-development`.

The plan lists every new helper by name. A helper only counts as approved when the owner approved a plan that
names it.

### 5. Helper gate: before any new shared code

Before you write any new helper (a utility function, extension, wrapper or small class) that is not named in a
plan the owner approved, load `jiance-stack:helper-gate` and run it: search for existing code, write the
justification, get a **fresh reviewer subagent's** verdict, and log it in your reply. Code shared by two call
sites, or placed outside the one function that uses it, is a new helper. Only private one-off code inside a
single function is not gated.

Run the gate when the plan names the helper, before the first line of it is written. If you find during
implementation that you need a helper the plan did not name, stop there and run the gate before you write it.

### 6. Implement with the testing rule

Every behaviour change goes through `jiance-stack:testing`: load it with the Skill tool before the first edit,
and follow its steps.

- **Test first.** Write the narrowest test of the intended behaviour, with a hand-written expected value,
  before any production code. For a bug, that is the regression test that reproduces the report.
- **Red, then green.** Run it and quote the failure for the right reason; make the smallest change; rerun the
  test and the project's full test command, and quote the pass.
- **Bad test: use a recorded substitute.** When an automated test would only repeat a value from the source
  (a colour in a stylesheet), test mocks, depend on timing, or need expensive setup, do not write it. Use the
  closest real check and **append its reason** to the project's test checklist or progress log now, with Edit
  (pre-authorized; plan or commit message when neither file exists). A substitute without a written reason does
  not count.
- **No shell.** Still write the test before the code. Say plainly that you could not run it and give the exact
  commands: the one that should fail before the change and pass after it. Write "not run" in the evidence;
  never invent output.
- Keep the change minimal: no options, refactors or features the request did not ask for. Fix the reported
  behaviour only; input that worked before keeps working unless the request or the contract says otherwise.
  Other gaps you notice go in the report as follow-ups, not into this change.

### 7. Blast radius and review

- **Blast radius.** Tiny: search for the other uses of what you changed and name them. Small and gated: load
  `jiance-stack:blast-radius` and prove the one fact the change's safety rests on, as far down its ladder as is
  cheap; say where it stopped.
- **Review.** Tiny: reread the diff against the request. Small and gated: `jiance-stack:requesting-code-review`
  dispatches a fresh reviewer subagent. Risky or contested changes (security, data loss, concurrency, a
  contract, the owner asked "are we sure?"): `jiance-stack:interrogate` as well.
- Act on findings with `jiance-stack:receiving-code-review`. A finding that suggests a new helper goes through
  the helper gate (step 5).

### 8. Update the project's own files, as its rules require

- Follow the role map. If the project's rules say "update PROGRESS.md in the same commit" or "every
  user-visible change gets a CHANGELOG entry", append one entry in that file's existing format and place, and
  touch nothing else in it. Write what was verified honestly: "Verify: `python -m pytest` (not run: no shell)"
  when it was not run.
- If the project has no such rule, do not edit its progress or changelog files (approval point). The test
  substitute's reason from step 6 is the one pre-authorized append.
- Never rewrite, reorder or reformat existing entries, and never edit other docs (README, CLAUDE.md, contracts)
  unless the change itself is a doc change the owner asked for or an approval point was passed.
- **Commit** in the project's format (the role map's principles row; Conventional Commits only where the project
  sets nothing), with the fix, its test and the progress or changelog entry together when the project's rule says
  "same commit". Commit only when the owner or the project's workflow asks for it; otherwise give the files and
  the message for that one commit. If you cannot commit (no shell), say so and give them the same way.

### 9. Verify, then report

Before the final reply, apply `jiance-stack:verification-before-completion` (load it if this session has not):

- Never write "fixed", "done", "works", "resolved", "passes", "should pass" or "should return" without
  quoting, in that reply, the output from this session that shows it. That includes the first line of the reply,
  the PROGRESS entry and the commit subject (say what the change does; a `fix:` type prefix is fine).
- **Could not run the command** (no shell, missing toolchain, hardware): open the reply with it ("I changed
  X; unverified: I could not run `<command>` because <reason>"), and give the exact command to run. Write any
  expected result once, labelled "Expected when you run it:", never as a statement about the code.
- End with this report, filled from real output:

```text
Change: <what changed, by file>
Status: verified (output below) | unverified: could not run <command> because <reason>
Testing evidence
- Test: <file>::<test> (or the substitute and where its reason is written)
- Order: test written before the fix (yes | no, and why)
- Failing before: <command> + quoted output, or "not run"
- Passing after: <command> + quoted output, or "not run"
Helper gate: <verdict block, or "no new helper">
Blast radius: <what else uses it, and where the proof stopped>
Project files: <entries appended, e.g. PROGRESS.md log entry>
Commit: <made: hash and message | to make: files + message>
```

## Red flags: stop

- About to edit code before the role map exists for this session.
- About to write production code before its test, or a substitute with no written reason.
- About to write a shared helper with no fresh reviewer verdict.
- About to edit a contract or a second module without the owner's OK on the plan.
- Editing a README, CLAUDE.md or contract the change did not need.
- "Fixed", "done" or "should pass" in a reply with no quoted output from this session.

## Common mistakes

| Mistake | Instead |
|---|---|
| Stopping after onboarding to wait for the structure offer | Make the change; put the offer at the end of the reply |
| A full brainstorm for a one-line value the owner named | One sentence of intent, then the change |
| "I've fixed it" when nothing ran | "I changed X; unverified: I could not run `<command>`" |
| Writing the PROGRESS entry as if the tests ran | Say what was run, and "not run" where it was not |
| Treating "go ahead" as approval of a new helper | Run the helper gate; only an approved plan or the owner's answer about that helper replaces it |
| Asking the owner before spawning the reviewer | This workflow is the request for reviewer subagents; spawn them |

## Related skills

- `jiance-stack:onboard-project`, `jiance-stack:testing`, `jiance-stack:helper-gate`,
  `jiance-stack:verification-before-completion`: the steps this workflow never skips.
- `jiance-stack:brainstorming`, `jiance-stack:writing-plans`: steps 3 and 4 for larger work.
- `jiance-stack:blast-radius`, `jiance-stack:requesting-code-review`, `jiance-stack:interrogate`: step 7.
- `jiance-stack:finishing-a-development-branch`: when the change lives on its own branch.
