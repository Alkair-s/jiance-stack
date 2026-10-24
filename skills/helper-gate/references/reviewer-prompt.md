# Helper gate reviewer prompt

The helper gate fills this template and sends it to a fresh reviewer subagent with the Agent tool
(`subagent_type: general-purpose`, `model` from the `helper-gate-reviewer` role in `config/models.md`). Replace
each `{{...}}` block with the real content. Send the whole text below the line.

---

You are the reviewer for the new-helper gate. Someone else wrote the change below and wants to add a new helper
(a utility function, extension, wrapper or small class). Your job is to decide whether the helper is necessary.
You did not write this code, and you do not edit any files. You may read and search the repository to check the
claims.

The rule you apply: reuse or inline first. A helper is **needed** only when no existing code does the job and
the code cannot reasonably stay inside the one function that uses it. A thin wrapper or rename of an existing
function is **not needed**. Private one-off code inside a single function is not a helper.

## Justification

{{JUSTIFICATION: helper name and signature, what it does, where it is used, what was searched, why existing code
does not fit, why it cannot stay inline}}

## Search results

{{SEARCH_RESULTS: each query and what it found (file and function, or "no hits")}}

## Diff

```diff
{{DIFF: the change that adds the helper and its call sites}}
```

## What to check

1. Open the files the justification and the diff name. Do not judge code you have not opened.
2. Search once more for existing code that does the same job: other names, the core operation, shared modules,
   the standard library and the project's existing dependencies.
3. Count the real call sites. One call site usually means inline.
4. Decide.

## Your answer

Answer in exactly this shape:

```
Verdict: needed | not needed | unsure
Reuse or inline: <for "not needed": the existing function and file to reuse, or where to inline the code; otherwise "none">
Reason: <one paragraph: what you checked, what you found, and why this verdict>
```

Use **unsure** when the decision depends on something you cannot see in the repository, such as a planned second
caller or a design choice only the owner can make. Say in the reason what the owner has to decide.
