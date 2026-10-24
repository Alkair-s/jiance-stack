---
name: interrogate
description: "Use for \"interrogate\", \"adversarial review\", \"multi-model review\", \"challenge this\", \"stress test this code\", \"find blind spots\", or \"tear this apart\". Multiple LLM reviewers challenge changes from independent angles."
---

> Adapted from cursor/plugins `pstack/skills/interrogate` at `e73df47` by Lauren Tan, MIT License. See NOTICE and UPSTREAM.md.

# Interrogate

Spawn one reviewer per review angle to adversarially review code changes. The adversarial signal comes from
diversity: the reviewers mix two models and each one looks through a different angle. The deliverable is a
synthesized verdict. Do NOT auto-apply changes.

**Asking for this skill is asking for subagents.** When the user asks to interrogate a change, or for an
adversarial, multi-model or "tear it apart" review, the user is explicitly asking you to use reviewer subagents. A
standing rule to spawn subagents only when the user asks for them is met by that request. Spawn the reviewers; do
not review the angles inline instead, and do not ask first.

Diversity today comes from the two models in `../../config/models.md` (the `reviewer-a` and `reviewer-b` roles)
plus the angles. Reviewers from other vendors are open item O1 in that file; when they arrive, only that file
changes.

## Step 1, Scope

Identify what to review from context:

- If the user points at specific files or a diff, use that.
- If on a feature branch, run `git diff main...HEAD` (or the appropriate base branch) for the full changeset.
  For staged work, `git diff --cached`. Without a shell, use the diff or files the user saved or named.
- If the user's message references recent work, gather the relevant files.

Package the diff or file contents with any surrounding context files the reviewers need to understand the code.

## Step 2, Intent

Before spawning reviewers, state the intent in one clear paragraph from the user's message, commit messages, the PR description if one exists, and the code. If you're unsure about the intent, ask the user before proceeding.

## Step 3, Spawn Reviewers

**Angles.** Take the angles from the "Reviewer angles" list in `../../config/models.md`: correctness, security,
performance, scalability, maintainability. Spawn one reviewer per angle that applies to the change. Skip an angle
only when it cannot apply (a docs-only change has no performance angle; a pure refactor with no input handling may
have no security surface), and name every skipped angle with a one-line reason. Correctness always applies. When
in doubt, keep the angle.

**Models.** Alternate the models over the reviewers in list order: the first reviewer uses the `reviewer-a` role,
the second `reviewer-b`, the third `reviewer-a`, and so on, so both models are always in the mix. Read the roles
from `../../config/models.md` (two directories up from this skill's base directory); a project's `CLAUDE.md`
`## Models` section overrides them. Only `opus` and `sonnet` are allowed: never `haiku` or a pinned older model ID.
An omitted `model` silently inherits the session's model, so always set it. If the Agent tool rejects a model
alias, say so and run that reviewer on the session default.

**Dispatch.** Launch all reviewers in a single message with the Agent tool, labeled Reviewer A, B, and so on.
Each reviewer gets `subagent_type: general-purpose`, not `Explore`: reviewers must read whole files and search
again, and Explore reads only excerpts. Each also gets its `model`; the prompt keeps it read-only. Reviewing the
angles inline yourself is not interrogate (see the top of this skill).

Read `references/reviewer-prompt.md` and fill in the same template for every reviewer with the stated intent, the
reviewer's angle, the diff or file contents, the rubric from `references/rubric.md`, and the code-quality lens. The
code-quality lens goes only to the maintainability and correctness reviewers: paste these sections of
`jiance-stack:thermo-nuclear-review` (`../thermo-nuclear-review/SKILL.md`) word for word, without rewriting
them: "Non-Negotiable Additional Standards", "Primary Review Questions", "What to Flag Aggressively" and
"Preferred Remedies". For the other angles, fill the lens with "none for this angle".

**Reasoning effort.** The Agent tool has no effort setting, so say it in the prompt. Tell each reviewer to read the
callers, callees and types around the change before judging it, to trace each finding to a concrete execution
path, and to stop when its angle is covered.

Only if this session has no Agent tool at all, say so, then review each angle yourself in turn with the same
template, and note in the verdict that every angle ran on one model.

## Step 4, Synthesize

As results come back, build a unified picture. Parse every reviewer's findings. Merge findings that describe the same issue differently, and note which reviewers (angle and model) raised each one. Findings two or more reviewers raised independently are the highest signal, most of all when they ran on different models. Read a lone reviewer's finding, but weight it accordingly; a finding inside its own reviewer's angle is not lone in that sense (see `references/lead-judgment.md`). Note disagreements. If one reviewer flags something and another explicitly says the opposite, that is context for the verdict.

## Step 5, Lead Judgment

You are the lead reviewer, a pragmatic senior engineer, not a neutral aggregator. Read `references/lead-judgment.md` for the full framework. Put every finding in one of four buckets, with the reviewer(s) that raised it and a one-line rationale.

- **Act on**. Real issues affecting correctness, security, or maintainability given the actual goals. They would block a real PR.
- **Consider**. Legitimate, but you're not sure they outweigh the cost of addressing them now. Worth the user's attention.
- **Noted**. Technically valid but not actionable. Context-dependent, premature optimization, or low-impact at this stage.
- **Dismissed**. Wrong, nitpicky, or missing context, with a brief reason.

**Lead judgment applies nothing.** It sorts findings; it does not edit, create or delete files, and it does not
commit. Fixes happen only when the owner asks, following `jiance-stack:receiving-code-review`. Security findings
go to the owner before any fix (approval point).

**New helpers.** A finding whose fix would add a new helper is marked "needs helper gate": before anyone writes it,
it passes `jiance-stack:helper-gate`. Prefer the fix that deletes or reuses code over one that adds code.

## Output Format

### Intent
> [The stated intent paragraph from Step 2]

### Reviewers
- Reviewer [label]: [angle], [model alias], [N findings] (one bullet per reviewer)
- Skipped angles: [each skipped angle with its reason, or "none"]

### Act On
[Each: description, which reviewers raised it, why it matters.]

### Consider
[Each: description, which reviewers raised it, the tradeoff.]

### Noted
[Brief list.]

### Dismissed
[Each with a brief rationale.]

### Agreement Map
[Where reviewers and models agreed and diverged, and what that pattern tells us.]
