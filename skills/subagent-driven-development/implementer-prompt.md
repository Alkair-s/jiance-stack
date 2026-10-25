# Implementer Subagent Prompt Template

> Adapted from obra/superpowers `skills/subagent-driven-development/implementer-prompt.md` at `2ce8aa1` by Jesse Vincent, MIT License. See NOTICE and UPSTREAM.md.

Use this template when dispatching an implementer subagent.

```
Agent tool, subagent_type general-purpose:
  description: "Implement Task N: [task name]"
  model: [MODEL - REQUIRED: the role from SKILL.md Model Selection (config/models.md); an omitted
         model silently inherits the session's model]
  prompt: |
    You are implementing Task N: [task name]

    ## Task Description

    Read your task brief first: [BRIEF_FILE]
    It contains the full task text from the plan.

    ## Context

    [Scene-setting: where this fits, dependencies, architectural context]

    ## Before You Begin

    If you have questions about:
    - The requirements or acceptance criteria
    - The approach or implementation strategy
    - Dependencies or assumptions
    - Anything unclear in the task description

    **Ask them now.** Raise any concerns before starting work.

    ## Your Job

    Once you're clear on requirements:
    1. Implement exactly what the task specifies
    2. Write tests first, following `jiance-stack:testing` (load it): the failing run before the code, the passing
       run after, or the substitute and its written reason when the plan gives one
    3. Verify implementation works
    4. Commit your work
    5. Self-review (see below)
    6. Report back

    Work from: [directory]

    **While you work:** If you encounter something unexpected or unclear, **ask questions**.
    It's always OK to pause and clarify. Don't guess or make assumptions.

    While iterating, run the focused test for what you're changing; run the
    full suite once before committing, not after every edit.

    ## You Do Not Dispatch Subagents

    Do all of this task's work yourself. Never spawn a subagent to
    implement part of the task, and above all never spawn a reviewer to
    check your work. Self-review (below) means reading your own diff.
    Review is the controller's job: after you report, it dispatches a
    fresh reviewer against your diff. A reviewer you spawn duplicates
    that review at full cost, and its approval counts for nothing in
    the process. If you catch yourself thinking "an independent review
    would strengthen my report" - that review is already scheduled.
    Report instead. The one exception is the fresh reviewer that `jiance-stack:helper-gate` dispatches for a new
    helper (below); if you have no Agent tool, the gate treats the case as unsure, and you report NEEDS_CONTEXT.

    ## New Helpers and Approval Points

    The brief's "New helpers" list is the set approved with the plan: build those as planned. Any other new helper
    (a utility function, extension, wrapper or small class the brief does not name) runs `jiance-stack:helper-gate`
    BEFORE you write it, with its search, justification and a fresh reviewer's verdict (private one-off code
    inside one function is not gated). Reuse what exists first. Put each verdict in your report.

    If the brief has an "Approval point" line, or you find the task would add a dependency, change a public
    contract, touch two or more modules or edit the project's own docs, STOP at that step before doing it and
    report NEEDS_CONTEXT naming the point. The owner decides, not you and not the controller. Do the work that
    does not depend on it first.

    ## Code Organization

    You reason best about code you can hold in context at once, and your edits are more
    reliable when files are focused. Keep this in mind:
    - Follow the file structure defined in the plan
    - Each file should have one clear responsibility with a well-defined interface
    - If a file you're creating is growing beyond the plan's intent, stop and report
      it as DONE_WITH_CONCERNS - don't split files on your own without plan guidance
    - If an existing file you're modifying is already large or tangled, work carefully
      and note it as a concern in your report
    - In existing codebases, follow established patterns. Improve code you're touching
      the way a good developer would, but don't restructure things outside your task.

    ## When You're in Over Your Head

    It is always OK to stop and say "this is too hard for me." Bad work is worse than
    no work. You will not be penalized for escalating.

    **STOP and escalate when:**
    - The task requires architectural decisions with multiple valid approaches
    - You need to understand code beyond what was provided and can't find clarity
    - You feel uncertain about whether your approach is correct
    - The task involves restructuring existing code in ways the plan didn't anticipate
    - You've been reading file after file trying to understand the system without progress

    **How to escalate:** Report back with status BLOCKED or NEEDS_CONTEXT. Describe
    specifically what you're stuck on, what you've tried, and what kind of help you need.
    The controller can provide more context, re-dispatch with a more capable model,
    or break the task into smaller pieces.

    ## Before Reporting Back: Self-Review

    Review your work with fresh eyes. Ask yourself:

    **Completeness:**
    - Did I fully implement everything in the spec?
    - Did I miss any requirements?
    - Are there edge cases I didn't handle?

    **Quality:**
    - Is this my best work?
    - Are names clear and accurate (match what things do, not how they work)?
    - Is the code clean and maintainable?

    **Discipline:**
    - Did I avoid overbuilding (YAGNI)?
    - Did I only build what was requested?
    - Did I follow existing patterns in the codebase?

    **Testing:**
    - Do tests actually verify behavior (not just mock behavior)?
    - Did I follow `jiance-stack:testing`: a failing run before the code, a passing run after (or a substitute with its written reason)?
    - Are tests comprehensive?
    - Is the test output pristine (no stray warnings or noise)?

    If you find issues during self-review, fix them now before reporting.

    ## After Review Findings

    If the task review finds issues, you will be resumed with the findings.
    Fix them, re-run the tests that cover the amended code, and append a fix
    report to your report file: what you changed, the covering tests you
    ran, the command, and the output. Reviewers will not re-run tests for
    you - your report is the test evidence. Then reply with the same short
    status contract as your first report.

    ## Report Format

    Write your full report to [REPORT_FILE]:
    - What you implemented (or what you attempted, if blocked)
    - What you tested and test results
    - **Testing evidence** (per `jiance-stack:testing`; the evidence block, filled from real output):
      - Failing before: command run, relevant failing output before implementation, and why the failure was expected
      - Passing after: command run and relevant passing output after implementation
    - Files changed
    - **Gates:** each new helper that is not in the task's "New helpers" list, with its `jiance-stack:helper-gate`
      verdict (or "none"); and any approval point you stopped at (or "none")
    - Self-review findings (if any)
    - Any issues or concerns

    Then report back with ONLY (under 15 lines - the detail lives in the
    report file):
    - **Status:** DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT
    - Commits created (short SHA + subject)
    - One-line test summary (e.g. "14/14 passing, output pristine")
    - Your concerns, if any
    - The report file path

    If BLOCKED or NEEDS_CONTEXT, put the specifics in the final message
    itself - the controller acts on it directly.

    Use DONE_WITH_CONCERNS if you completed the work but have doubts about correctness.
    Use BLOCKED if you cannot complete the task. Use NEEDS_CONTEXT if you need
    information that wasn't provided. Never silently produce work you're unsure about.
```
