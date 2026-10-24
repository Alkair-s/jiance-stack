# jiance-stack: design

**Date:** 2026-10-24 · **Status:** approved by the owner (2026-10-24)
**Name:** jiance-stack, from 检测工具 (jiǎncè gōngjù, "inspection / testing tool")
**Repo:** public on GitHub, installable as a Claude Code plugin

## 1. Intent

jiance-stack packages a way of working with AI coding agents that was proven on a real project: the Wall Rose
Android app (a no-root per-app VPN auditor), built end to end with Claude Code in eight days, from a planning brief
to a measured, security-reviewed v1.0.0. What made that project work was not the code but the method around it:

- a planning brief, then a technical document written for the agent, then milestones;
- a short root `CLAUDE.md` that routes to one contract per module, so an agent loads one module, never the
  whole codebase;
- a decision log with reasons and rejected alternatives, and a progress file that is the single source of truth;
- hard approval points, real command output instead of claims, tests that fail first, measured performance
  targets, a security review before release, and mechanical checks written as scripts.

The owner wants that method reusable on any project, combined with the best parts of two existing skill sets:
**superpowers** (Jesse Vincent, MIT; strongest on tests, plans and subagent execution) and **pstack** (Lauren Tan,
MIT; strongest on investigation, teaching, writing quality, adversarial review and measurement).

**Who it is for:** the owner first (next use: extending an existing project, then new projects from scratch), and
anyone on GitHub who installs it.

**Success looks like:** on a new or existing project, the agent follows the same discipline Wall Rose had without
the owner re-explaining it, wastes less context, adds less unneeded code, and every "it works" comes with the
command output that proves it.

## 2. Goals, non-goals, anti-goals

**Goals**

1. Three areas of skills: (1) new project from scratch, (2) fixes and features in existing projects, (3) general
   purpose.
2. A default set of principles every project starts from, which a project can override only by an explicit,
   written decision.
3. Templates for every document the method uses.
4. Self-contained: every skill taken from superpowers, pstack or thermos is copied in, adapted and credited. One
   router, one testing rule.
5. Respect for existing projects: on a structured project, adapt to its files and rules, never rewrite them.

**Non-goals**

- Not Android-specific. Stack-specific material (Gradle dependency audit, on-device checklists) appears only as
  examples inside general skills.
- Does not run the phase-1 planning conversation inside Claude Code (the owner plans in a separate chat).
- No multi-vendor model routing in v1 (see §10, open item O1).
- No CI templates, no telemetry, no network calls of its own.

**Anti-goals** (failure even if everything "works")

- Two or more routers or testing rules competing for the same request. superpowers and pstack are not meant to
  be installed next to jiance-stack: the README says to disable them, and the session-start hook warns when it
  detects them (owner, 2026-10-24).
- The plugin editing an existing project's own docs, principles or structure without explicit approval.
- Personal details (devices, local paths, names, account data) in the public repo.
- Upstream work used without clear credit.
- Tests written to satisfy a process rather than to catch a real break.

## 3. Constraints

- Claude Code plugin format: `.claude-plugin/plugin.json`, a `marketplace.json` so the repo installs with
  `/plugin marketplace add <owner>/jiance-stack`, skills as `skills/<name>/SKILL.md`, hooks in `hooks/hooks.json`.
- Licences: superpowers (MIT, © 2025 Jesse Vincent), pstack (MIT, © 2026 Lauren Tan), thermos (MIT, © 2026
  Cursor). MIT requires keeping the copyright and permission notice with copied substantial portions.
- Subagent models: only Opus 5.5 / Sonnet 5.5 or newer. No older models.
- The repo follows its own default principles (§5): English, UTF-8 without BOM, ASCII-only code, no em dashes in
  docs, Conventional Commits.
- One planning skill must also work outside Claude Code (uploadable as a skill to a claude.ai chat), so it cannot
  rely on Claude Code tools.

## 4. Approaches considered

| | Approach | Trade-off |
|---|---|---|
| A | Depend on superpowers and the pstack Claude Code port; add only new skills | Least code, free upstream updates; but three routers and two TDD skills compete, pstack keeps its Cursor model setup, and the owner's changes exist only as fragile overrides |
| B | Hybrid: depend on superpowers, copy and adapt pstack | Less copying; but superpowers' own router and strict TDD stay installed and keep firing |
| **C** | **Self-contained: copy, adapt and credit every skill used** | One coherent system with the owner's rules built in; costs maintaining the copies and syncing upstream by hand |

**Chosen: C** (owner, 2026-10-24). Reason: the owner's rules change upstream behaviour in several places (testing
mix, reviewer models, new-helper gate, adapting to existing projects); in A and B those changes would fight the
original skills on every trigger. C also makes the credit explicit.

## 5. Default principles (decided with the owner)

Shipped as `principles/defaults.md`. Each rule has an ID, the rule, and its reason. New projects get a copy in their
own docs; on existing projects they apply where the project's own rules are silent (§7.2).

| ID | Rule |
|---|---|
| P1 | Fewest dependencies possible. When one is reasonably needed: newest stable, safest, not deprecated, no relocated or empty-shim artifacts, no known vulnerabilities (OSV.dev), transitive dependencies included. |
| P2 | No new dependency without the owner's approval and a size estimate. |
| P3 | English only for docs and code. UTF-8 without BOM. Source code is ASCII only; non-ASCII user-visible text lives in resource or translation files. Docs may use Unicode, but never em dashes. |
| P4 | Report real command output, never claims or assumptions. |
| P5 | Build modular, scalable and safe. |
| P6 | Every rule carries its reason. Decisions are logged with rejected alternatives; nothing is re-decided silently. New evidence goes to the owner, and work stops. |
| P7 | Modules talk only through their contracts. Read the contract of a module you call, never its internals. Public contract changes need approval. A short root `CLAUDE.md` routes to one `CLAUDE.md` + contract per module. |
| P8 | Minimal changes. No features, options or abstractions "for completeness". New helpers pass the new-helper gate (§6.4). |
| P9 | The testing rule (§6.3). |
| P10 | Measure, don't guess. Performance targets have a target, a hard limit and a measuring method; misses are reported before optimizing. |
| P11 | Safe defaults: fail closed; never log secrets, payloads or user data; no telemetry unless the project decides it. |
| P12 | Never reason about code that has not been opened. Fix root causes, not symptoms. |
| P13 | Progress is updated in the same commit as the work. Commits follow Conventional Commits with the module as scope (`fix(relay): ...`; breaking contract changes `feat(packet)!:` plus a `BREAKING CHANGE:` footer; releases `chore(release): vX.Y.Z`). One branch per milestone, merged after the owner's OK. |
| P14 | Focused files of about 300 lines; split by responsibility beyond that. |

**Overrides:** a project overrides a default only with a dated entry in its own decision log, e.g. "D12 overrides
P14: generated parsers may exceed 300 lines, because ...". The plugin honours only written overrides.

**Enforcement as structure** (pstack "encode lessons in structure"): P3 ships as `scripts/check-encoding.sh`
(fails on non-ASCII bytes in source files, a BOM in any text file, or an em dash in docs). New projects get it
through the templates; the plugin repo runs it on itself.

## 6. Cross-cutting rules

### 6.1 Precedence

1. The owner's direct instructions in the session.
2. The project's own rules (its `CLAUDE.md`, contracts, principles, decision log, including written overrides).
3. jiance-stack defaults (§5).
4. Individual skill instructions.

pstack's "never block on the human" applies only to reversible work outside the approval points of §6.2; the
approval points always win.

### 6.2 Approval points (stop and wait)

- public contract or invariant changes;
- changes touching two or more modules (present a plan first);
- new dependencies (P2);
- security-review findings, before any fix;
- missed performance targets, before any optimizing;
- setting up structure on an unstructured project (§7.3);
- any edit to an existing project's own docs or principles that its rules do not already ask for;
- new helpers when the reviewer is unsure, or always when the project sets "always ask" (§6.4).

### 6.3 Testing rule (mix of superpowers and pstack)

- **Every new feature gets tests** (superpowers). When an automated test would be a bad test (below), a recorded
  substitute is enough: a checklist item, a reproduction script or a measured run, with the reason it replaces an
  automated test written explicitly in the project's documentation (the plan and the progress log, or the test
  checklist). A substitute without a written reason does not count.
- **Bug fixes get a regression test when a sensible one exists** (pstack).
- **Steps** (pstack): write the narrowest test of the intended behaviour; run it and show it fails for the right
  reason (fix the test first if it passes or fails for another reason); make the smallest change; rerun it and the
  nearby suite and show the pass.
- **Report evidence:** the failing-before run and the passing-after run, quoted (P4).
- **Skip bad tests on purpose, never silently.** A bad test mostly tests mocks, mirrors the implementation,
  depends on timing or global state, or needs expensive setup for a small change. Then use the closest real check
  (script, reproduction command, log assertion, manual checklist item) and say so.
- **Guardrails:** fix the code, not the test; never weaken an assertion to go green; a test that contradicts the
  contract goes to the owner; flaky tests are rerun in a loop and made deterministic or reported.

### 6.4 New-helper gate (owner's rule)

When a change would add a new helper (utility function, extension, wrapper or small class not named in the
approved plan or contract):

1. Search the codebase for something that already does the job.
2. Write a short justification: what it does, where it is used, what was searched, why existing code does not fit.
3. A fresh reviewer subagent (one that did not write the code) returns **needed**, **not needed** (with what to
   reuse or inline), or **unsure** (goes to the owner).
4. The verdict is logged with the other rulings of the task.

The owner's direct answer about a specific helper is also a verdict (the owner's words: "evaluated by me or by a
reviewer"), logged the same way. A general "go ahead" on the task is not an answer about a helper.

Not gated: private one-off code inside a single function; helpers listed in a plan the owner approved. A project
may set "always ask the owner". Review findings that suggest extracting a helper (e.g. from the thermo-nuclear
lens) pass the same gate; reviews prefer deleting or reusing code over adding it.

### 6.5 Models

One file, `config/models.md`, lists which model each role uses (reviewers, explorers, explainers, implementers).
v1 allows only Opus 5.5 and Sonnet 5.5 or newer. Skills that spawn subagents read it; a project can override it
in its own `CLAUDE.md`. Diversity in multi-reviewer skills comes from mixing those two models and giving each
reviewer a different angle (correctness, security, performance, scalability, maintainability). Adding other
vendors later only changes this file (O1).

## 7. The three areas

### 7.1 Area 1: new project from scratch

1. **`planning-brief`** (portable; for the separate planning chat). Guides the planning conversation and writes
   the brief in the proven shape: instructions for the next phase, objective, non-negotiable constraints,
   decisions each with reasoning, reversed decisions flagged so they are not reopened, the per-entity state
   model or core concept table where one exists, error-handling requirements, testing strategy, explicitly
   rejected items, and open items left for the technical document. Uses no Claude Code tools.
2. **`import-brief`** (Claude Code). Takes the brief dropped into a new repo and:
   - reviews it and flags anything unworkable, contradictory or better done another way, without changing it
     silently;
   - checks current toolchain and dependency versions live (P1), never from memory;
   - writes the technical document (section index, RFC 2119 words, every rule with its reason, diagrams,
     threading, schemas, error matrix, security invariants, performance targets table, testing strategy, known
     limitations, review focus);
   - writes the module contracts, the root router `CLAUDE.md` and one `CLAUDE.md` per module, `DECISIONS.md`
     (brief decisions plus review decisions, rejected list), `PROGRESS.md` with milestones and their verify
     commands, the default principles, and, where they apply, `TEST_CHECKLIST.md` and `BUILD_AND_RELEASE.md`;
   - stops for the owner's approval before any code.
3. **`run-milestone`**. The PROGRESS procedure: plan (via `writing-plans`), approval, task-by-task with the
   testing rule, verify commands with real output pasted into the log, boxes ticked only when verify passes, a
   "next session must know" line.
4. **`performance-targets`**. Define targets with hard limits and methods, add debug-only instrumentation,
   measure at the end, vet every number with `benchmark-checklist`, report misses before optimizing.
5. **`security-review`**. Before the first release: review against the project's security invariants and
   review-focus list, findings to the owner before fixes, fixes test-first, accepted risks written into known
   limitations.
6. **`manual-release`**. Version bump, changelog, build, verify signature/checksum, smoke test on the real target,
   tag, publish by hand. Artifacts and secrets stay out of the repo.

### 7.2 Area 2: existing project

1. **`onboard-project`** runs first on an existing codebase. It looks for structure (router `CLAUDE.md`,
   contracts, decisions, principles, progress, changelog).
   - **Structured:** maps those files to the method's roles ("their CONTRIBUTING.md plays the principles role"),
     reports the map, and from then on treats them as the rules. It never rewrites, reformats or migrates them,
     and only appends where the project's own rules say to (e.g. "update PROGRESS in the same commit").
     jiance-stack defaults fill only the gaps those files leave; where the project's rules and a default
     conflict, the project wins and the conflict is mentioned once.
   - **Unstructured:** goes to `setup-structure`.
2. **`setup-structure`** offers the full structure (router `CLAUDE.md`, per-module `CLAUDE.md` and contract,
   decisions, progress, testing and release docs where they fit) and waits for explicit approval. If approved, it
   writes contracts from what the code does today, marks anything unclear as an open question instead of
   inventing it, and the owner reviews everything before commit. If declined, the project uses area-3 skills only,
   and the offer is not repeated (recorded in the project's Claude Code memory, not in its files).
3. **`change-request`**: the workflow for a fix, a feature or new tests on an existing project: understand
   (`how`, and `why` when the reason matters) → short brainstorm → plan (approval points apply) → implement with
   the testing rule and the helper gate → `blast-radius` → review (`interrogate` for risky or contested changes) →
   verification → update the project's own progress/changelog as its rules require.

### 7.3 Area 3: general purpose

| Skill | Source | What changes from the source |
|---|---|---|
| `using-jiance` (router) | superpowers `using-superpowers`, pstack `poteto-mode` | One router: picks the area, lists triggers, states §6.1 precedence; injected at session start by the hook |
| `how` | pstack | Claude Code subagents; models from `config/models.md` |
| `why` | pstack | Evidence from git, docs, and whatever MCPs are connected; degrades to git + docs when none |
| `teach` | pstack | as source |
| `unslop` | pstack | as source; also applied to the plugin's own docs |
| `technical-writing` | pstack | as source, aligned with P3 |
| `evaluate-principles` | new | Reads a project's principles with its code and history; per principle: what it protects, where code follows or drifts, what could be stronger (missing reason, unenforced rule, conflict, gap). Suggests only; edits nothing without approval |
| `testing` | superpowers TDD + pstack `tdd` | The §6.3 rule |
| `helper-gate` | new | §6.4 |
| `interrogate` | pstack, with thermos `thermo-nuclear-code-quality-review` as its code-quality lens | Reviewers per §6.5 (models + angles); lead judgment synthesizes, applies nothing |
| `thermo-nuclear-review` | thermos | Standalone strict maintainability review; helper suggestions go through §6.4 |
| `blast-radius` | pstack | as source |
| `benchmark-checklist` | pstack | as source |
| `show-me-your-work` | pstack | Decision trail for long or autonomous work (Wall Rose's "Ruling: ... cost if wrong" ledger) |
| `create-verification-skill` | pstack | Turns a repeated check into a project script or skill (P10, encode lessons in structure) |
| `dependency-hygiene` | new (Wall Rose D29) | P1/P2 procedure: live version check, OSV query, transitive audit, pins and documented hold-backs; per-ecosystem examples |
| `engineering-principles` | pstack `principle-*` | One skill with an index and one reference file per principle, loaded on demand (guards the context window instead of 23 separate skill descriptions) |
| `brainstorming`, `writing-plans`, `executing-plans`, `subagent-driven-development`, `dispatching-parallel-agents`, `systematic-debugging`, `verification-before-completion`, `requesting-code-review`, `receiving-code-review`, `using-git-worktrees`, `finishing-a-development-branch`, `writing-skills` | superpowers | References to superpowers' TDD point to `testing`; plan and review steps include the helper gate and approval points |

Left out of v1 (candidates later): pstack `architect`, `arena`, `swarm`, formal-verification skills, `statechart`,
`no-comments`, `typescript-best-practices` and the persona/utility skills; superpowers `diagnosing-superpowers`.

### 7.4 Brainstorming as a first-class step

The superpowers `brainstorming` skill (owner: "very valuable") is part of the core, not an optional extra. The
router sends any request to create or change behaviour through it first, sized to the work: `change-request`
starts with it, `import-brief` uses it while reviewing the brief, and `planning-brief` follows the same method in
the separate chat.

### 7.5 Delivery in stages (owner, 2026-10-24)

- **Stage 1** (the owner's next use, extending an existing project): router and hook, `onboard-project`,
  `setup-structure`, `change-request`, `brainstorming`, `writing-plans`, `executing-plans`,
  `subagent-driven-development`, `testing`, `helper-gate`, `blast-radius`, `interrogate`,
  `thermo-nuclear-review`, `how`, `why`, `teach`, `unslop`, `evaluate-principles`,
  `verification-before-completion`, `systematic-debugging`, the code-review pair, `principles/defaults.md`,
  `config/models.md`, `check-encoding.sh`, the credit files. Stage 1 must work as a coherent system on its own.
- **Stage 2:** area 1 (`planning-brief`, `import-brief`, `run-milestone`, `performance-targets`,
  `security-review`, `manual-release`), the remaining area-3 skills, and the templates stage 1 does not need.

## 8. Repository layout

```
jiance-stack/
  .claude-plugin/plugin.json, marketplace.json
  hooks/hooks.json, session-start          injects using-jiance at session start
  skills/<name>/SKILL.md (+ references/)   flat: Claude Code discovers skills one level deep
  principles/defaults.md                   P1-P14 with reasons
  templates/                               planning brief, technical document, module contract,
                                           root and module CLAUDE.md, DECISIONS, PROGRESS, CHANGELOG,
                                           TEST_CHECKLIST, BUILD_AND_RELEASE
  config/models.md
  scripts/check-encoding.sh
  docs/specs/                              this design and later ones
  docs/case-study.md                       how the method ran on Wall Rose, without personal details
  README.md, CHANGELOG.md, LICENSE (MIT), NOTICE, UPSTREAM.md
```

Areas are not folders (skills must sit one level deep); the router and README group them.

## 9. Credit and licence

- `LICENSE`: MIT for jiance-stack.
- `NOTICE`: the full MIT notices of superpowers, pstack and thermos, with a thank-you paragraph naming Jesse
  Vincent, Lauren Tan and Cursor.
- Each adapted skill begins with a credit line: source repo, path, author, licence, and "adapted".
- `UPSTREAM.md`: for each adapted skill, the upstream commit it came from (today: superpowers `obra/superpowers`
  at `2ce8aa1`, plugin v7.0.1; pstack and thermos `cursor/plugins` at `e73df47`) and a summary of what was
  changed, so re-syncing is deliberate.
- README "Credits" section with the same names and links.

## 10. Decided by the owner (summary)

Self-contained approach C; three areas; adapt to structured projects without editing them; offer structure on
unstructured ones only with approval, else general skills; planning in a separate chat, technical document in
Claude Code from the imported brief; router `CLAUDE.md` per module as a core rule; default principles P1-P14 with
written overrides; Conventional Commits; ASCII-only source, Unicode docs without em dashes; testing rule as in
§6.3; new-helper gate; reviewers on Opus/Sonnet 5.5+ with different angles; added skills interrogate +
thermo-nuclear and blast-radius + benchmark-checklist; public repo, no personal details, explicit MIT credit;
recorded test substitutes allowed only with a written reason; superpowers/pstack disabled alongside jiance-stack;
brainstorming as a core step; delivery in two stages.

**Open items for later:** O1, other-vendor reviewers in `interrogate` once available (only `config/models.md`
changes).

## 11. Calls made by the designer (owner to check)

- Precedence order of §6.1 and "project wins over defaults on conflict" in §7.2.
- Not gated by the helper rule: private one-off code and helpers in an approved plan.
- `engineering-principles` as one skill with references instead of 23 skills.
- The v1 inventory and the left-out list in §7.3.
- A declined structure offer is remembered in Claude Code memory, not in the project.
- Wall Rose is named as the origin and case study (it is already public), with no devices, paths or personal data.

- **Sources for templates:** the Wall Rose documents in its public repo (technical document, decisions,
  progress, contracts, `CLAUDE.md` files, test checklist, build and release guide) plus the planning brief, which
  is not in that repo and is supplied to the builder separately. Templates are generalized from them, never
  copied verbatim; the case study quotes only short excerpts from the public repo.
- **Upstream to copy from:** the originals (`obra/superpowers`, `cursor/plugins` for pstack and thermos). The
  community Claude Code port of pstack may be read for Claude Code mechanics but is not copied, so it is not an
  upstream.
- **Router strength:** lighter than `using-superpowers`. The injected text picks the area, lists the trigger
  table and §6.1 precedence; a skill check is required before non-trivial work, not before every reply.
- **Declined structure offer:** remembered in Claude Code auto-memory when it is on; when it is off, the plugin
  asks once per session in one line. Nothing is written into the project.
- **`planning-brief` delivery:** marked not model-invocable in Claude Code and absent from the router; each
  release also ships it as a zip asset with upload instructions for claude.ai.

- **Examples** in skills, templates and docs (owner, 2026-10-24): language-agnostic where possible (pseudocode,
  plain descriptions). When a concrete language is needed, prefer Python, Go or PowerShell. Kotlin and Wall Rose
  may appear only alongside such examples, never as the only one.

## 12. Left to the builder

- Wording of each adapted skill, within the credit and P3 rules.
- The session-start hook's script language (must run in Git Bash on Windows and in POSIX shells).
- Exact template contents, derived from the Wall Rose documents and generalized.
- How each skill is checked before release (the `writing-skills` pressure-test method, `claude plugin eval`, or
  both), as long as every new or changed skill has at least one recorded behaviour check.
