---
name: onboard-project
description: "Use when starting work on an existing codebase: find its rules and structure (CLAUDE.md, contracts, decisions, principles, progress, changelog), map them to jiance-stack roles and follow them without editing them; offer setup-structure only when structure is missing."
---

# Onboard project

Find the files where an existing project keeps its rules, map each one to a jiance-stack role, report that map,
and from then on follow those files as the project's rules. You are a reader here, not an editor.

Run it at the start of the first project task in a session: "get your bearings", a fix, a feature, a review, even
a commit message or a changelog line. It is cheap: list the tree, read the rule files, report. Skip it when this
session already produced the map.

## The rule that comes first

**Onboarding writes nothing into the project.** No new file, no edit, no "small fix" to a typo in their
CONTRIBUTING.md, no reformatting, no migration to jiance-stack names. The project's files belong to the
project. Structure is added only by `jiance-stack:setup-structure`, and only after the owner explicitly says yes
to an offer you made in your reply.

## Step 1: look

List the tree (Glob `**/*`) and read every file that can hold a rule. Never classify a file you have not opened
(P12 in `../../principles/defaults.md`). A section counts as a file: a README "Development" section is a rule
file even though the rest of the README is usage text. One file can play several roles, and one role can have
several files.

| Role | What it does | Typical names, and how to recognise it in other formats |
|---|---|---|
| router | Tells an agent where things are and how to work; points to the module docs | `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `.github/copilot-instructions.md`, `.cursor/rules/`; any file that lists modules and "read X before Y" |
| contract | One module's purpose, public API, behaviour and invariants | `docs/contracts/*.md`, a `CLAUDE.md` or `README.md` inside a module folder, `docs/api/`, OpenAPI or `.proto` files with prose, a package doc comment that states guarantees |
| decisions | What was decided, why, and what was rejected | `DECISIONS.md`, `docs/adr/`, `docs/decisions/`, a "Decisions" or "Design notes" section; dated entries with a reason |
| principles | Rules for every change: style, testing, commits, review | `CONTRIBUTING.md`, `STYLE.md`, a README "Development" or "Contributing" section, "Hard rules" in a router; linter and formatter configs that encode a rule (`.golangci.yml`, `ruff.toml`, `PSScriptAnalyzerSettings.psd1`, `.editorconfig`) |
| progress | What is done, what is next, the verify commands | `PROGRESS.md`, `TODO.md`, `ROADMAP.md`, milestone docs, a status table in the README |
| changelog | User-visible changes per release | `CHANGELOG.md`, `HISTORY.md`, `NEWS`, `RELEASES.md` |
| test checklist | Manual or measured checks that replace automated tests | `TEST_CHECKLIST.md`, `docs/testing.md`, `QA.md`, a "Manual checks" section |

A README that only explains what the tool does and how to install it is not a rule file. A README that says
"run the tests before every commit" is one (principles role).

## Step 2: classify

- **Structured:** the router role and the contract role are both filled. Follow the files. Roles with no file
  are covered by the jiance-stack defaults; say which defaults apply. Do not offer `setup-structure` and do not
  offer to add files.
- **Partial:** at least one role is filled (a README with development rules, a CONTRIBUTING.md, a CHANGELOG, a
  linter config), but the router or the contracts are missing. Follow what exists as the project's rules. Offer
  only the missing roles, by name ("a router CLAUDE.md, module contracts, a decision log and a progress file"),
  never a rewrite, move or merge of the files that exist. Ask once and wait for an explicit yes.
- **Unstructured:** no role is filled: code, build files, maybe a usage-only README. Offer the full structure
  that `jiance-stack:setup-structure` writes: a short router `CLAUDE.md` that routes to one `CLAUDE.md` plus
  contract per module (so an agent loads one module, never the whole codebase), contracts written from what the
  code does today, a decision log and a progress file, plus testing or release docs where the project has such
  steps. Ask once and wait for an explicit yes.

Name each piece in the offer by its file and role, so the owner knows what they are saying yes to: "a root
`CLAUDE.md` (router), `store/CLAUDE.md` and `docs/contracts/store.md` (contract, written from the code as it
is), `DECISIONS.md` (decision log), `PROGRESS.md` (progress)". "Some project docs" is not an offer.

Before you offer anything, check Claude Code auto-memory for a decline on this project. If the owner already
declined, do not offer again; one line in the map notes says "structure declined earlier; general skills only".

An offer is a question at the end of your reply, not a plan you start on. Writing even one file of the offer
before the owner answers breaks the approval point "setting up structure on an unstructured project".

## Step 3: report the role map

This table is the interface other skills read (`jiance-stack:evaluate-principles`,
`jiance-stack:brainstorming`, `jiance-stack:change-request`). Keep its shape exactly:

- First line: `Project: <structured | partial | unstructured>`.
- Then a table with the columns `Role | File(s) | Notes`, one row per role, always all seven rows, in this order:
  router, contract, decisions, principles, progress, changelog, test checklist.
- **File(s):** paths as found, with a section name when only a section plays the role
  (`README.md` "Development"). `none` when no file plays the role.
- **Notes:** the rules from that file you will follow, in a few words each, or which default covers a
  `none` row (`defaults P13 apply`). Compare every filled row with `../../principles/defaults.md` to find
  the conflicts. Write a conflict as `replaces P<n>` in its Notes cell, unless the same reply already states
  it in a sentence: the owner hears about each conflict once per session, not twice in one reply.

Example for a partial project:

```
Project: partial

| Role | File(s) | Notes |
|---|---|---|
| router | none | defaults apply; offer below |
| contract | none | defaults P7 apply; offer below |
| decisions | none | defaults P6 apply |
| principles | `README.md` "Development", `ruff.toml` | `python -m pytest` before every commit; `core` does no I/O; ruff rules |
| progress | none | defaults P13 apply |
| changelog | `CHANGELOG.md` | entry under `## Unreleased` in the same commit as each user-visible change |
| test checklist | none | substitutes go in the commit message (see jiance-stack:testing) |
```

After the table, say in a few lines how you will work here: the project's rules first, the defaults only where
the table says `none`, and the approval points. End with the offer when Step 2 calls for one.

The map lives in this conversation. Do not write it into the project. Save it to auto-memory only when the
owner asks you to keep it.

## Following the rules after onboarding

- **Project wins.** Where a project file and a jiance-stack default disagree, the project's convention wins.
  Say so once, at the point where it first matters, in one sentence that names the project's rule and the
  default it replaces: "STYLE.md allows files up to 600 lines, so I keep `parser.go` whole instead of
  splitting it at the default 300 (P14)." Name the default. "This follows STYLE.md" alone does not tell the
  owner that a default was set aside. Do not repeat it later in the session.
- **Rules apply to everything you produce,** not just code: commit messages, changelog lines, branch names,
  file layout, test style. Before writing one of those, check the map for the row that governs it.
- **Defaults fill gaps only.** A `none` row means the default applies. A filled row means the default for that
  topic does not, even when you prefer it.
- **A written override is a rule.** A dated decision that overrides a default (see `../../principles/defaults.md`
  "Overrides") is followed like any other project rule.

## Appending to the project's files

Append only where the project's own rules say to, for example "update PROGRESS.md in the same commit" or "every
user-visible change gets a CHANGELOG entry". Then append the new entry in the file's existing format and
place, and touch nothing else in the file.

One more append is pre-authorized: the written reason for a test substitute (`jiance-stack:testing`,
"Substitutes"), in the test checklist or progress file.

Every other edit to a rule file (rewording, reformatting, fixing a stale command, adding a section) is an
approval point: propose the exact change in your reply and wait.

## When the owner declines the offer

- Use the general skills only (`jiance-stack:using-jiance` lists them) and the project's existing files as
  its rules. Nothing is written into the project to record the decline.
- Record the decline in Claude Code auto-memory, one line: the project, the date, "owner declined
  jiance-stack structure; do not offer again". Memory is not a project file.
- If auto-memory is off or not writable, do not offer again in this session, and in a later session ask at most
  once, in one line ("Want the jiance-stack structure here? You said no last time; I'll not ask again this
  session.").

## Common mistakes

| Mistake | Instead |
|---|---|
| "I'll add a CLAUDE.md so I remember the rules" | Offer it; write nothing until the owner says yes |
| Rewriting the README's rules into a new CONTRIBUTING.md | Map the README section to the principles role and follow it |
| Offering the full structure on a partial project | Offer only the missing roles |
| Offering structure on a structured project because a role is empty | Note the `none` row and the default that covers it |
| Following the default commit format because the project's rule is in another file | Check the map before writing a commit message |
| Mentioning the same conflict in every reply | Once, where it first matters |
