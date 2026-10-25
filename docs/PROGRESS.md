# Progress

The state file for jiance-stack (P13): what is done, what is next, and what was decided on the way. Update it in
the same commit as the work it describes. Newest log entry first.

Design: `docs/specs/2026-10-24-jiance-stack-design.md`. Stage 1 plan: `docs/plans/2026-10-24-stage-1.md`.

## Milestones

### Stage 1: existing projects and core skills (v0.1.0, 2026-10-25)

- [x] Repo skeleton, manifests, LICENSE, NOTICE, UPSTREAM.md, `scripts/validate-skills.sh`
- [x] `scripts/check-encoding.sh` (P3)
- [x] `principles/defaults.md` (P1-P14) and `config/models.md`
- [x] Router `using-jiance` and the session-start hook (warns when superpowers or pstack is installed)
- [x] `testing`, `helper-gate`
- [x] `brainstorming`, `writing-plans`, `executing-plans`, `subagent-driven-development`, `using-git-worktrees`,
      `finishing-a-development-branch`
- [x] `verification-before-completion`, `systematic-debugging`, `requesting-code-review`, `receiving-code-review`
- [x] `how`, `why`, `teach`, `unslop`, `evaluate-principles`
- [x] `interrogate`, `thermo-nuclear-review`, `blast-radius`
- [x] `onboard-project`, `setup-structure`, project templates
- [x] `change-request`
- [x] README, case study, changelog; final whole-branch review and its fix wave
- [x] Published: github.com/Alkair-s/jiance-stack, tag `v0.1.0`

**Open checks for stage 1:**

- [ ] Owner: local install check. In Claude Code run `/plugin marketplace add Alkair-s/jiance-stack`, then
      `/plugin install jiance-stack@jiance-stack`, start a new session, and confirm the router text is injected and
      `/jiance-stack:teach` is listed. Disable superpowers first (the hook warns if it is still installed).
- [ ] Re-run the unstable eval cases at `--runs 3` after the usage limit resets (see the log below):
      `change-request-fix`, `helper-gate-new`, `router-change-request`.
- [ ] Run the brainstorming visual companion once on a machine with Node.js (`skills/brainstorming/scripts/`);
      it was edited but never executed.
- [ ] Create a GitHub Release for `v0.1.0` (optional; the tag exists).

### Stage 2: new projects (not started)

- [ ] `planning-brief` (portable; also packaged as a zip for claude.ai; not model-invocable in Claude Code)
- [ ] `import-brief` (review the brief, write the technical document, contracts, router `CLAUDE.md`s, DECISIONS,
      PROGRESS, TEST_CHECKLIST, BUILD_AND_RELEASE; stop for approval before code)
- [ ] `run-milestone`
- [ ] `performance-targets` (uses `benchmark-checklist`)
- [ ] `benchmark-checklist` (from pstack)
- [ ] `security-review`
- [ ] `manual-release`
- [ ] `engineering-principles` (pstack `principle-*`, one skill with one reference per principle)
- [ ] Templates not needed by stage 1: planning brief, technical document, TEST_CHECKLIST, BUILD_AND_RELEASE,
      CHANGELOG
- [ ] Router: remove the "not shipped yet" note for these skills

### Later

- [ ] O1: reviewers from other vendors in `interrogate` (only `config/models.md` changes)
- [ ] Candidates left out of v1: pstack `architect`, `arena`, `swarm`, formal-verification skills, `statechart`

## Parked items (decided, revisit when convenient)

- `systematic-debugging/SKILL.md` (313 lines) and `subagent-driven-development/SKILL.md` (306 lines) are slightly
  over the ~300-line guideline (P14).
- `systematic-debugging/references/condition-based-waiting-example.ts` is the upstream TypeScript example; add a
  Python or Go one next to it.
- Where specs and plans go in a project with no rules for it (final review M9): a structure decision for the owner.
- `scripts/validate-skills.sh` checks only the credit-line prefix and one-line descriptions.
- `scripts/check-encoding.sh`: a tracked file deleted locally reports `read-error`; the explicit-directory branch
  does not use `-z`; files with NUL bytes are skipped as binary.
- `how-walkthrough`, `onboard-structured` and `helper-gate-private` pass without the plugin too: they guard
  against regressions, they do not show a gain.
- No eval covers: remembering a declined structure offer (the eval sandbox blocks the memory folder),
  `setup-structure` itself, the `why` MCP sources, the shell path of `blast-radius`.

## Decisions taken during stage 1

Owner decisions:

- unslop stays exactly as upstream; parentheses in the plugin's own files are fine.
- A test substitute counts only with its reason written in the project's documentation.
- The owner's direct answer about a helper is a helper-gate verdict.
- Reviewers use only Opus 5.5 / Sonnet 5.5 or newer, with different angles; other vendors later (O1).
- superpowers and pstack are disabled next to jiance-stack.

Rulings made while building (each can be revisited):

- The testing rule covers changes that add or alter observable behaviour; a refactor, rename or config change
  needs only the existing suite green.
- Appending a test substitute's reason to the project's progress log or test checklist is pre-authorized
  (append only). With neither file, the reason goes in the plan or the commit message. An explicit owner limit on
  files wins.
- Security findings from any review are an owner approval point before any fix.
- Every small change gets one code reviewer (design §7.2 makes review unconditional; about 0.7 USD per eval run).
- Every skill that spawns subagents says "invoking this skill is asking for subagents", because Claude Code's own
  prompt otherwise discourages spawning.
- The verification core rule lives in the router, always in context, not only in its skill.
- `interrogate` and helper-gate reviewers are `general-purpose` subagents (they read whole files); `how` explorers
  are `Explore`.
- The brainstorming visual companion is kept (Node built-ins only, text fallback); upstream's remote-logo request
  was removed (P11).
- Skills that quote two upstreams carry one credit line per source.
- Windows evals have no shell tool, so graders judge transcripts and accept "could not run, here is the command"
  in place of quoted output, never a success claim without output.

## Log

- 2026-10-25: **Stage 1 published** as v0.1.0. GitHub had created an initial LICENSE commit; it was merged
  keeping the repo's LICENSE (copyright `Alkair-s`). Eval re-runs after the fix wave, one or two runs per case,
  plugin arm vs no-plugin baseline:
  - pass with a gain: `interrogate-diff` 1 vs 0, `helper-gate-justify` 1 vs 0, `testing-bad-test` 1 vs 0,
    `blast-radius-proof` 1 vs 0, `brainstorming-scope` 1 vs 0, `testing-feature` 1 vs 0, `verify-claims` 1 vs 0, `plan-has-gates` 1 (baseline errored),
    `onboard-partial` 1 vs 0.67, `onboard-unstructured` 1 vs 0.67, `onboard-rule-wins` 0.83 vs 0.67,
    `evaluate-principles` 1 vs 0.5;
  - pass, no gain (regression guards): `helper-gate-private` 1 vs 1, `how-walkthrough` 1 vs 1,
    `onboard-structured` 1 vs 1;
  - unstable: `change-request-fix` 0.5 vs 0 (the reply opened with "I fixed" while nothing had run; fixed in
    c1b7cda, not re-measured yet), `helper-gate-new` 0.5 vs 1 (the skill did not fire in one run);
  - not measured: `router-change-request` (usage limit).
  Eval spend: about 25 USD across the full suite and re-runs.
- 2026-10-24: Stage 1 built with subagent-driven development: 15 tasks, each with a task review and fix rounds,
  then a whole-branch review (0 Critical, 5 Important, 13 Minor) and one fix wave (all Important and 11 Minor
  fixed, re-review approved).
- 2026-10-24: Design approved; stage 1 plan written.
