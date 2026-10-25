---
name: how
description: "Use for \"how does X work\", code walkthroughs before changing something, and placement / ownership / layering questions (\"where should this live\", \"which package owns this\", \"is this the right layer\"). Explains subsystem architecture, runtime flow, onboarding mental models. Use why for motivation."
---

> Adapted from cursor/plugins `pstack/skills/how` at `e73df47` by Lauren Tan, MIT License. See NOTICE and UPSTREAM.md.

# How

Explore the codebase to answer "how does X work?" questions. Produce architectural explanations at the level of a senior engineer onboarding onto a subsystem, enough to build a working mental model, not so much that it reads like annotated source code.

**Invoking this skill is asking for subagents.** When the owner asks how something works and this skill runs, the
owner is explicitly asking for its explorer and explainer subagents. A standing rule to spawn subagents only when
the user asks is met by that request. Spawn them; do not explore inline instead, and do not ask first.

Every spawn uses the Agent tool with `subagent_type: Explore`, which is read-only. Set `model` from
`../../config/models.md`: explorers use the `explorer` role, and every explainer uses the `explainer` role. An omitted
`model` silently inherits the session's model, and `haiku` is never allowed. If the Agent tool rejects a model alias, say so and
continue with the session default.

**Reasoning effort.** The Agent tool has no effort setting, so say it in the prompt. Tell an explorer to trace its
slice fast and to stop once the flow is clear. Tell an explainer to reconcile the findings carefully and to check any
contradiction in the code itself.

If the Agent tool is not available, do the exploring and explaining yourself with Read, Grep and Glob, following the
same steps and the same prompts.

## 1. Assess complexity

If the scope is ambiguous, state your interpretation and explore. The user can redirect.

**Focus.** Note what the asker is about to change or work on ("I am about to change the store"), if they said. That is the focus: the depth of every explorer and the explainer goes there, and the rest stays short. With no stated focus, leave it as "none". Always give file and line references for the steps that matter.

- **Simple** (a single module, a small utility, a narrow question such as "how does function X work"): no explorers. Spawn one explainer that explores and explains in one pass, built from `references/explainer-prompt.md` (focus filled in) without the explorer-findings section. Go to step 4.
- **Complex** (a subsystem spanning multiple files or services, a cross-cutting feature, a full architectural overview): go to step 2.

When in doubt, take the simple path.

## 2. Explore (complex only)

Decompose the question into 2 to 4 angles, each a distinct slice of the subsystem. Make sure one angle covers the focus in depth. Spawn all explorers in a single message, each with `references/explorer-prompt.md`, its angle and the focus filled in.

## 3. Synthesize (complex only)

Once all explorers have returned, spawn one explainer with `references/explainer-prompt.md`, with every explorer's findings and the focus filled in.

## 4. Present

Present the explainer's output. Light edits for clarity or context from the conversation are fine. Do not substantially rewrite it.

## Output format

The explanation uses the sections defined in `references/explainer-prompt.md`, dropping any that do not apply: Overview, Key Concepts, How It Works, Where Things Live, Gotchas.
