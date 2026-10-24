---
name: testing
description: "Use when implementing a feature or fixing a bug: every new feature gets tests, bug fixes get a regression test when a sensible one exists; write the narrowest test, show it fail for the right reason, make the smallest fix, rerun and show it pass; skip bad tests only with a written reason."
---

> Adapted from obra/superpowers `skills/test-driven-development` at `2ce8aa1` by Jesse Vincent, MIT License. See NOTICE and UPSTREAM.md.
> Adapted from cursor/plugins `pstack/skills/tdd` at `e73df47` by Lauren Tan, MIT License. See NOTICE and UPSTREAM.md.

# Testing

Tests are the proof that behaviour works. This skill is the jiance-stack testing rule (principle P9): test every
new feature, skip bad tests on purpose and never silently, and prove each change with a failing run before and
a passing run after.

**Core principle:** if you did not watch the test fail, you do not know that it tests the right thing.

This applies to every change, even one line. A style, copy or config edit that no sensible test covers still
gets its recorded substitute, with the reason appended to the project's test checklist or progress log before
you reply (see "Substitutes"); "too small to check" is not a reason.

## The rule

- **Every new feature gets tests.** When an automated test would be a bad test (see below), a recorded
  substitute is enough: a checklist item, a reproduction script or a measured run. The reason it replaces an
  automated test is written explicitly in the project's documentation: the plan and the progress log, or the
  test checklist. **A substitute without a written reason does not count.**
- **Bug fixes get a regression test when a sensible one exists.** If no cheap, focused test path exists, use the
  closest real check and say so (see "Substitutes").
- **Report evidence:** the failing-before run and the passing-after run, quoted (P4). Never a claim without the
  output.

## The steps

Do these in order, for each behaviour.

1. **Understand the behaviour.** Name the intended behaviour, the current behaviour and the smallest observable
   example (an input and the output it should give). For a bug, find the smallest reproduction.
2. **Choose the narrowest check.** Prefer the closest unit or integration test the project already uses for that
   code path. Decide now whether an automated test would be a bad test; if so, go to "Substitutes".
3. **Write the narrowest test first.** One behaviour, a clear name, real code, expected values written by hand
   (literals), not computed by the code under test. Write no production code yet: no stub, export, import
   wiring or config edit before the test file is written.
4. **Run it and show it fails for the right reason.** The failure must be the missing behaviour, not a typo, an
   import error in the test, or a broken fixture. If it passes, it tests something that already works: fix the
   test. If it fails for another reason, fix the test or the reproduction first, then run it again.
5. **Make the smallest change** that makes the test pass. No extra options, no refactor of other code, no
   features the test does not ask for. A new helper goes through `jiance-stack:helper-gate`.
6. **Rerun the test and the nearby suite and show the pass.** Run the project's own test command, not only
   your file. Any failure you see, including one you did not cause, goes in the report by name.
7. **Clean up while green.** Rename and remove duplication, then rerun. Do not add behaviour.

**When the change gets no automated test** (step 2 found it would be a bad test), steps 3 to 7 become:

3. **Make the smallest change.**
4. **Run the closest real check** (see "Substitutes"), or say it is not run and why.
5. **Record the substitute and its reason.** Append one item to the project's test checklist or progress log
   (plan or commit message if neither exists): what is checked, how, and why an automated test would be a bad
   test here. This append is pre-authorized. Do it before you report done; the change is not done without it.
6. **Report** the substitute, the check's result and where the reason is written.

Wrote production code before the test? Set it aside, write the test, watch it fail against the code without
the change, then bring the change back. A test written after the code passes at once and proves nothing.

**Missing names.** A first run that fails only because the new function does not exist yet (Go
`undefined: ParseSize`, a Python `ImportError` for the new name) shows the test reaches the right code, but it
does not show the assertion works. Add an empty stub (returns a zero value), run again, and quote the assertion
failure. That is the red run to report.

## When you cannot run the tests

Some sessions have no shell tool, or the toolchain is missing. Then:

- Still follow the steps: write the test file first, then the production code, in that order.
- Say plainly that you could not run it, and why (no shell, no interpreter).
- Give the exact commands the owner should run: the one that should fail now (before the change) and the one
  that should pass after it, with the result each should show.
- **Never claim a run you did not do.** No "the test fails", "all green" or invented output. Write "not run"
  in the evidence report.

## Bad tests: skip them on purpose, never silently

A test is a bad test when it mostly:

- tests mocks instead of the real code (asserts that a mock was called, not what the code produced);
- mirrors the implementation (the expected value is computed by the same code or its helpers, or the test
  checks private structure that only a redesign would change);
- pins a decision instead of a behaviour (a constant, a colour value, exact wording, a style property): it fires
  on every intentional change and never on a bug;
- depends on timing, ordering or global state (sleeps, wall clock, shared files, network);
- needs expensive setup for a small change (a full browser harness, production-only state, large fixture churn);
- would be deleted right after it proved the fix.

Prefer no new automated test over a bad one. Never write a bad test just to satisfy this rule.

## Substitutes

When an automated test would be bad, use the closest real check and record it:

| Substitute | Use it for | Evidence |
|---|---|---|
| Checklist item | Visual or manual behaviour (layout, colour, copy) | The item, how to check it, the result when checked |
| Reproduction script | A bug that needs a real environment | The script, its output before and after |
| Measured run | Performance, size, timing targets | The command, the numbers before and after |
| Log assertion | Behaviour visible only in logs | The command, the log line expected and seen |

For every substitute, before you reply:

1. **Append the reason to the project's documentation now, with Edit or Write**: the progress log or the test
   checklist (`docs/test-checklist.md` or the project's equivalent) when one exists. Add one item that says what
   is checked, how, and why an automated test would be a bad test here. Append only; never rewrite existing
   entries. A reason given only in your reply does not count.
2. **This append is pre-authorized.** Writing a substitute's reason is part of the owner's testing rule, so it
   is not an "edit to the project's own docs" that needs approval. Do not ask; do it. The record is part of
   the change itself: "this is the whole change", "only touch this file" or "no questions" still include it.
   Search for the file first (Glob for `*checklist*`, `*progress*`, `PROGRESS*`, `docs/`).
3. If neither a progress log nor a test checklist exists, put the reason in the plan or in the change's commit
   message, and tell the owner where it went.
4. Say in your reply that you used a substitute, which one, and where the reason is written.

Example checklist item for a style change:

```markdown
- [ ] Footer links show #0B6E4F on the home page (open the page, inspect a footer link).
  Why manual: an automated test would only repeat the CSS value (a change detector); no visual test harness.
```

## Evidence report

End the work with this block, filled from real output (P4):

```text
Testing evidence
- Test: <file>::<test name> (or the substitute and where its reason is written)
- Failing before: <command>
  <quoted output, the lines that show the failure and its reason>
- Passing after: <command>
  <quoted output, including the nearby suite summary>
- Not run: <what could not be run, and why> (omit when everything ran)
```

If failing-before evidence could not be shown, say why and name the closest check used instead.

## Guardrails

- Fix the code, not the test. Never change a test to match a wrong implementation.
- Never weaken, delete or skip an assertion to go green. If the expected behaviour has truly changed, say so and
  why, in the report.
- A test that contradicts the contract (the spec, the documented behaviour, the decision log) goes to the owner.
  Do not pick a side.
- Flaky tests: rerun in a loop to measure (for example 20 runs), then make the test deterministic (inject the
  clock, fix the seed, remove shared state) or report it with the failure rate. Never mark it skipped silently.
- Keep a regression test focused on the bug. Wider coverage of the same class of bug comes after, as its own step.
- Mocks only when the real dependency is slow or external, and only after you know its side effects.

## Rationalizations

| Excuse | Reality |
|---|---|
| "Too simple to test" | Simple code breaks. The test takes a minute. |
| "I'll test after" | A test written after passes at once and proves nothing. |
| "I already checked it by hand" | Not recorded, not repeatable. Record it as a substitute with a reason, or write the test. |
| "This test would be bad, so no check" | A bad test is replaced by a recorded substitute, never by nothing. |
| "The run would pass anyway" | Then run it and quote it. No output, no claim. |

## Red flags: stop

- Production code written before its test.
- A new test that passed on its first run.
- You cannot say why the test failed.
- A substitute with no written reason in the project's docs.
- A report that says "tests pass" without quoted output.

## Language examples

Language-agnostic shape, then concrete ones in `references/examples.md`:

1. Test file: one test that calls the new function with a hand-picked input and asserts the literal output.
2. Run the project's test command on that test: it fails, and the failure names the missing behaviour.
3. Smallest code change.
4. Run the same command, then the whole suite: both pass.

- Python (pytest): `python -m pytest tests/test_units.py::test_parse_size_megabytes` then `python -m pytest`.
- Go: `go test ./sizes -run TestParseSize` then `go test ./...`.

## Related skills

- `jiance-stack:systematic-debugging` finds the root cause of a bug before the regression test is written.
- `jiance-stack:helper-gate` before adding a helper the plan did not name.
- `jiance-stack:verification-before-completion` before saying the work is done.
