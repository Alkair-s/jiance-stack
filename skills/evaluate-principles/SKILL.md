---
name: evaluate-principles
description: "Use when asked to review, explain or improve a project's principles, rules or CLAUDE.md: for each principle explain what it protects, where the code follows or drifts from it, and what could be stronger; suggests only, edits nothing without approval."
---

# Evaluate principles

Read a project's written rules next to its code and history, explain each rule, show where the code keeps it and
where it drifts, and suggest how the rules could be stronger. You are an assessor, not an editor.

## The rule that comes first

**Suggest only. Change no file unless the owner approves a specific change.** Not the rule files, not the code,
not a config file, not even to fix an obvious drift. A broken rule found here is a finding to report, not a task
to do. "Looks good, go ahead" after the report approves nothing specific: ask which suggestion they want applied.
When the owner names one ("apply suggestion 2"), make exactly that change and stop. The project's rule files
belong to the project (`jiance-stack:onboard-project` never rewrites them either), so a proposed rewording
goes in the answer, not in the file.

## Inputs

1. **The principle files.** Use the role map from `jiance-stack:onboard-project` when it ran in this session or
   the owner kept it in memory: its `Role | File(s) | Notes` table, where the router, contract, decisions and
   principles rows name the rule files (for example `principles | CONTRIBUTING.md`). When there is no map, find
   them yourself: `CLAUDE.md` at the root and in modules, `CONTRIBUTING.md`, `AGENTS.md`, `docs/principles*`,
   decision logs (`DECISIONS.md`, `docs/adr/`), contracts, style guides, linter configs that encode a rule.
   Say in the answer that you found them yourself and list which files you treated as rules.
2. **The code.** Open the files a rule speaks about. Never judge a rule against code you have not read (P12 in
   `../../principles/defaults.md`). Search for each rule's tell (for a "wrap every returned error" rule in
   Go, search for a bare `return err`).
3. **Git history, when a shell is available.** `git log --oneline -- <rule file>` shows when a rule arrived;
   `git log -S '<pattern>'` shows when a drift came in. Without a shell, say that history was not read.
4. **The reference sets.** `../../principles/defaults.md` (P1-P14, the jiance-stack defaults) and
   `references/pstack-principles.md` (one line per pstack principle). Use them only for the gaps column.

When "why does this rule exist" matters and the file gives no reason, you may run `jiance-stack:why` with one
narrow question about that rule (git plus the repo docs). This is optional; skip it for small rule sets.

## Per principle

For each rule, find four things.

1. **What it protects.** The failure the rule prevents and why it seems to exist. Quote the written reason if
   there is one. If you infer the reason, say it is inferred.
2. **Follows.** Where the code keeps the rule, with `file:line`.
3. **Drifts.** Where the code breaks it, with `file:line` or a commit hash. Quote the offending line. "None
   found" is a valid answer when you searched; say what you searched for.
4. **Could be stronger.** Check each of these:
   - **Missing reason.** The rule gives no "why" (P6: every rule carries its reason). Offer a one-line reason.
   - **Unenforced.** Nothing checks the rule, yet a script could: a lint rule, a test, a CI step, a pre-commit
     hook. Name the concrete check and the rule id it uses (for a Go "wrap errors" rule: the `wrapcheck`
     lint; for a PowerShell "no Write-Host" rule: PSScriptAnalyzer `PSAvoidUsingWriteHost`). A rule that the
     code already breaks and nothing checks is the strongest candidate.
   - **Vague.** A word the rule depends on is undefined ("internal", "public", "small").
   - **Conflict.** Two rules that pull against each other, or a rule that clashes with a jiance-stack default.
     Under the precedence the project's rule wins; say so once and move on.
   - **Gap.** Something `../../principles/defaults.md` or `references/pstack-principles.md` covers that the project
     is silent on, raised only when the code shows the problem (a project with no test rule and one test is a
     gap; a project with no idempotency rule and no retried steps is not).

## Output

First a table, one row per rule:

| Rule | Protects | Follows | Drifts | Could be stronger |
|---|---|---|---|---|
| 1. Wrap returned errors with context | an error says where it came from | `store/save.go:18` `fmt.Errorf("save: %w", err)` | `store/load.go:31` bare `return err` | no reason given; enforce with the `wrapcheck` lint in CI |

Then a ranked suggestion list, most important first, and say that it is ranked. Rank by harm: a live drift
that nothing checks comes before a missing reason, which comes before wording. Each item says what to change,
in which file, and why. Mark which suggestions add a dependency or tool (P2: the owner approves those with a
size estimate).

End with one line: which suggestions you can apply if the owner approves them, by number. Nothing changed yet.

Write the answer through `jiance-stack:unslop`. Report what you searched as you searched it (P4); do not claim a
rule is followed everywhere when you read only part of the code.

## Common mistakes

| Mistake | Instead |
|---|---|
| Fixing the drift "while you are there" | Report it with `file:line`; fix only on a specific approval |
| Rewriting the rule file as a suggestion and saving it | Put the proposed text in the answer |
| "Consider adding linting" | Name the check and the rule id it enforces |
| Listing every pstack principle as a gap | Raise a gap only when the code shows the problem |
| Judging a rule from its wording alone | Open the code it governs and cite lines |
