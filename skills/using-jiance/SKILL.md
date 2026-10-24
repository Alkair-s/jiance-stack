---
name: using-jiance
description: "Use at the start of every session and before any non-trivial task: picks the jiance-stack area (existing project, new project, general), states rule precedence, and lists which skill to run first."
---

# Using jiance-stack

jiance-stack is a skill stack for disciplined coding work: inspect, test, prove. This router tells you which
skill to run first. It is light on purpose: check for a skill before non-trivial work, not before every reply.

If you were dispatched as a subagent for one specific task, skip this router and do that task.

## Rule precedence

When rules conflict, the higher one wins:

1. The owner's direct instructions. 2. The project's own rules (CLAUDE.md, contracts, principles, decision log, written overrides). 3. jiance-stack defaults (principles/defaults.md). 4. Individual skill instructions.

The defaults live in `principles/defaults.md` and the model for each subagent role lives in `config/models.md`,
both in this plugin. A project's own files override them where they speak.

## When to check for a skill

- Before non-trivial work: anything that creates or changes behaviour, touches more than one file, needs a
  plan, debugs a failure, reviews code, or claims that work is done.
- Not before every reply. A quick factual answer, a one-line clarification or reading a file the owner pointed
  at needs no skill.
- Load a skill with the Skill tool, by its full name, for example `jiance-stack:change-request`. Say which skill
  you are using and why, in one sentence.
- If a skill you need is not available, say so and follow the steps in this router instead. Never skip the
  approval points because a skill is missing.

## Brainstorming first

Brainstorming comes first for anything that creates or changes behaviour, sized to the work. A small flag or
fix gets a few questions about intent and edge cases. A new feature or module gets the full design
conversation. Do not write or edit code until the owner has confirmed what they want.

## Pick the area

1. **Existing project.** The repo already has code. Run `jiance-stack:onboard-project` once per project to map
   its rules, then use `jiance-stack:change-request` for every fix, feature or new test.
2. **New project from scratch.** An empty or nearly empty repo, or a planning brief to turn into a project.
   The new-project skills (planning-brief, import-brief, run-milestone and the rest) are stage 2 and not
   shipped yet (see below). For now, use `jiance-stack:brainstorming`,
   then `jiance-stack:writing-plans`, and follow the plan with the approval points below.
3. **General purpose.** Questions, reviews, explanations, writing and debugging that are not tied to a
   project workflow. Pick from the trigger table.

If you cannot tell which area applies, ask the owner one short question.

## Trigger table

| Request type | First skill |
|---|---|
| First session on an existing codebase | `jiance-stack:onboard-project` |
| Existing project has no structure (no CLAUDE.md, contracts or decision log) | `jiance-stack:setup-structure` |
| Fix, feature, flag, option or new tests on an existing project | `jiance-stack:change-request` |
| Create or change behaviour, design an idea, "let's build X" | `jiance-stack:brainstorming` |
| Agreed spec or design that needs a step-by-step plan | `jiance-stack:writing-plans` |
| Approved plan to carry out in this session | `jiance-stack:executing-plans` |
| Approved plan with independent tasks for subagents | `jiance-stack:subagent-driven-development` |
| Work that needs an isolated branch or checkout | `jiance-stack:using-git-worktrees` |
| Work done, tests pass, decide how to integrate the branch | `jiance-stack:finishing-a-development-branch` |
| Writing or changing code that needs tests | `jiance-stack:testing` |
| About to add a helper, wrapper or utility not named in the plan | `jiance-stack:helper-gate` |
| Before committing a change: what else can it break | `jiance-stack:blast-radius` |
| Risky or contested change, "are we sure?" | `jiance-stack:interrogate` |
| Strict maintainability review of a diff or module | `jiance-stack:thermo-nuclear-review` |
| "How does X work?", explain a system or a non-trivial change | `jiance-stack:how` |
| "Why was X built this way?", history and reasons | `jiance-stack:why` |
| Teach a concept or a codebase to the owner | `jiance-stack:teach` |
| Prose for people: docs, READMEs, commit messages, replies | `jiance-stack:unslop` |
| Judge a project's own principles against its code | `jiance-stack:evaluate-principles` |
| About to say work is done, fixed or passing | `jiance-stack:verification-before-completion` |
| A bug, a failing test or unexpected behaviour | `jiance-stack:systematic-debugging` |
| A task or feature is complete and needs review | `jiance-stack:requesting-code-review` |
| Review feedback has arrived | `jiance-stack:receiving-code-review` |

When more than one row fits, run the process skill first (brainstorming, change-request, systematic-debugging),
then the skills it calls. Examples: "add a retry option to the upload command" on an existing repo starts with
`jiance-stack:change-request`; "the nightly job fails since Monday" starts with
`jiance-stack:systematic-debugging`; "how does the cache get invalidated?" starts with `jiance-stack:how`.

## Approval points: stop and wait

Stop and wait for the owner's explicit OK before any of these. They hold even when other guidance says to keep
going on reversible work.

- public contract or invariant changes;
- changes touching two or more modules (present a plan first);
- new dependencies;
- security-review findings, before any fix;
- missed performance targets, before any optimizing;
- setting up structure on an unstructured project;
- any edit to an existing project's own docs or principles that its rules do not already ask for;
- new helpers when the reviewer is unsure, or always when the project sets "always ask".

## Working habits

- Read code before reasoning about it. Fix root causes, not symptoms.
- Report real command output, never claims.
- Keep changes minimal. No features, options or abstractions that were not asked for.
- Every new feature gets tests; a bad test is replaced on purpose by a recorded substitute with a written reason.

## Not shipped yet (stage 2)

These skills are planned and not part of this version: `planning-brief`, `import-brief`, `run-milestone`,
`performance-targets`, `security-review`, `manual-release`, `technical-writing`, `benchmark-checklist`,
`show-me-your-work`, `create-verification-skill`, `dependency-hygiene`, `engineering-principles`,
`dispatching-parallel-agents` and `writing-skills`. Do not try to load them. When a task needs one, say it is not
shipped yet and use the closest stage-1 skill or the steps in this router.
