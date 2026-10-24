---
name: helper-gate
description: "Use before adding a new helper (utility function, extension, wrapper or small class) that the approved plan or contract does not name: search for existing code, justify, and get a fresh reviewer's verdict."
---

# Helper gate

This is the owner's rule (principle P8, design 6.4): if a completely new helper would be implemented, the owner
or a reviewer first judges whether it is necessary. Every helper is code that someone has to read, test and
maintain, and a second copy of something the codebase already has drifts away from the first.

**Core principle:** reuse or inline first. A new helper has to earn its place, and someone other than its
author decides.

## When the gate applies

A change would add a new **helper**: a utility function, an extension, a wrapper or a small class that the
approved plan or the contract does not name. A function that only wraps or renames an existing one is a new
helper too.

### Not gated

- **Private one-off code inside a single function**: a local lambda, a sort key, a nested function or a few
  inline lines that live in that one function and are used only there. Write it and move on: no search write-up,
  no justification, no reviewer subagent, no question to the owner.
- **Helpers listed in a plan the owner approved.** The approval already covered them. Build them as planned.

If the private code later moves out of its function (module level, a shared file, a second caller), it is a new
helper from that moment and passes the gate.

**"Go ahead" is not a helper approval.** The owner asking for the feature ("add that", "no questions needed, go
ahead", "both modules need it") approves the change, not a new helper you chose to write for it. The gate is the
owner's own rule, so it still runs: search, justify, fresh reviewer, log. Only a plan the owner approved that
names the helper, or the owner's direct answer about this specific helper, replaces the reviewer. The rule is
"evaluated by me or by a reviewer", so the owner's answer is a verdict: log it in step 4 like any other.

### "Always ask the owner"

A project may set "always ask the owner" for new helpers (in its `CLAUDE.md`, contracts or decision log). Then
steps 1 and 2 still run, and the owner gives the verdict instead of the reviewer: present the justification and
the search results, then stop and wait (approval point). Log the owner's answer as the verdict (step 4).

## The steps

Do these in order, before you write the helper.

### 1. Search for something that already does the job

Search the codebase before writing anything:

- Grep for the obvious names and their synonyms (`slug`, `slugify`, `to_slug`, `url_name`), for the core
  operation (the regex, the format string, the API call) and for the types involved.
- Glob for shared places: `utils/`, `helpers/`, `common/`, `lib/`, `internal/`, `pkg/`, string or date modules.
- Check the standard library and the dependencies the project already has.
- Write down each query and what it found (file and function, or "no hits").

**If the search finds code that does the job, reuse it.** Call the existing function directly where it is
needed. Do not wrap it in a new function of your own, even a one-line wrapper. No new helper means the gate is
done: no justification and no reviewer. Say in the reply what you reused and where it lives.

If a few inline lines at the one call site do the job, inline them instead (that is private one-off code).

### 2. Write a short justification

Only when a new helper still seems needed. Keep it to a few lines:

```
Helper:     <name and signature>
Does:       <what it does, one sentence>
Used by:    <call sites, current and planned in this change>
Searched:   <queries and hits from step 1>
Why not existing code: <why each hit does not fit, or "no hits">
Why not inline: <why the code cannot stay inside one function>
```

### 3. Get a fresh reviewer's verdict

Dispatch a reviewer subagent with the Agent tool:

- `subagent_type: general-purpose`, not `Explore`: the reviewer must read whole files and search again, and
  Explore reads only excerpts.
- `model`: the `helper-gate-reviewer` role in `config/models.md` at the plugin root (two directories up from this
  skill's base directory: `../../config/models.md`). A project's `CLAUDE.md` `## Models` section overrides it.
  Today that is `sonnet`.
- prompt: `references/reviewer-prompt.md` in this skill's directory, with the justification, the search results
  and the diff filled in.

The reviewer must be **fresh**: a subagent that did not write the code. Never give the verdict yourself, and
never ask the implementer subagent that wrote the helper.

The reviewer returns one verdict and a one-paragraph reason:

| verdict | what you do |
|---|---|
| **needed** | Add the helper as justified. |
| **not needed** | Do what the reviewer names instead: reuse the existing code it points to, or inline the code. Do not add the helper. |
| **unsure** | Approval point: stop, show the owner the justification and the reviewer's reason, and wait for their decision. |

If the reviewer's answer has no clear `needed`, `not needed` or `unsure` verdict, treat it as **unsure**: it goes
to the owner. If the Agent tool is not available, say so and treat the case as **unsure**: the owner decides.

### 4. Log the verdict

Log the gate with the other rulings of the task:

- During plan execution, in the task's rulings or ledger file when one exists.
- Otherwise in your reply to the owner.

The log is a short block, so the owner can check the gate without the transcript: the justification from step 2
(what the helper does, where it is used, what you searched and found, why existing code does not fit) and the
verdict line. A bare "the reviewer agreed" is not a log.

```
Helper gate: <helper name>
Does / used by: <one line>
Searched: <queries and hits>; existing code does not fit because <reason>
Verdict: <needed | not needed | unsure> (fresh reviewer, <model>). <one-sentence reason>
```

When the owner decided (an `unsure` verdict, a malformed reviewer answer, "always ask the owner", or the owner's
direct answer about this helper), the verdict line names the owner and gives the owner's reason:

```
Verdict: owner: <needed | not needed>. <the owner's reason, in their words where possible>
```

## Review findings that suggest a helper

A code review (for example `jiance-stack:thermo-nuclear-review` or `jiance-stack:requesting-code-review`) may
suggest extracting a helper. That suggestion passes the same gate before anyone writes it. Reviews prefer
deleting or reusing code over adding it.

## Examples

**Reuse (Python).** The task asks for a function that turns titles into URL slugs. The search finds
`slugify` in `utils/strings.py`, already used by the site pages. The change imports it and calls it where the
slug is needed:

```python
from blog.utils.strings import slugify

entry["slug"] = slugify(article["title"])
```

No `title_to_slug` wrapper, no reviewer. Reply: "Reused `slugify` from `utils/strings.py`; no new helper."

**Private one-off code (Python).** Sorting rows inside `build_report` needs a key:

```python
rows.sort(key=lambda row: (-row["total"], row["name"]))
```

It lives in that one function. Not gated.

**Gated (Go).** A change needs to retry an HTTP call in two packages. The search finds no retry code in the repo
and none in the existing dependencies. The justification names both call sites and explains why a loop inline in
each would duplicate the backoff logic. The reviewer returns `needed`, and the log line reads:

```
Helper gate: retry.Do(ctx, attempts, fn)
Does / used by: retries a call with backoff; used by upload/client.go and sync/fetch.go
Searched: grep "retry|backoff|attempt" (no hits), go.mod deps (none fit); existing code does not fit because none exists
Verdict: needed (fresh reviewer, sonnet). Two call sites would otherwise duplicate the backoff logic.
```

## Red flags

Stop and go back to step 1 when you notice any of these:

- You are about to write a helper and have not searched.
- You found an existing function and are writing a thin wrapper around it "for clarity".
- You plan to judge your own helper, or to ask the subagent that wrote it.
- You are running the gate on a lambda or a few lines inside one function (it is not gated).
- The reviewer said `unsure` and you are about to go ahead anyway.

## Related skills

- `jiance-stack:using-jiance`: rule precedence and the approval points.
- `jiance-stack:testing`: a helper that is added still gets its tests.
