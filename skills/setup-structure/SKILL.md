---
name: setup-structure
description: "Use only after the owner explicitly approves adding the jiance-stack structure to an existing project: write the router CLAUDE.md, per-module CLAUDE.md and contracts from what the code does today, plus decisions and progress."
---

# Set up structure

Add the jiance-stack structure to an existing project: a short root `CLAUDE.md` that routes to one `CLAUDE.md`
plus contract per module, a decision log and a progress file, written from the code as it is today. The point is
context: an agent reads the router, then one module's `CLAUDE.md` and contract, and never has to load the whole
codebase.

## Step 0: approval check

Before anything else, find the owner's explicit yes in this conversation: an answer to the offer from
`jiance-stack:onboard-project` ("yes, set it up", "add the contracts and the progress file") or a direct request
("set up the jiance-stack structure here"). "Get your bearings", "go ahead with the task" or silence is not a
yes to structure.

- No yes: write nothing. Make the offer (or run `jiance-stack:onboard-project`, which makes it) and stop.
- A yes to some pieces (a partial project): write only those pieces. Everything that already exists stays as it
  is; the new router links to it instead of copying it.
- A decline recorded in auto-memory: do not offer again (see `jiance-stack:onboard-project`).

## Step 1: read the code

Never describe code you have not opened (P12 in `../../principles/defaults.md`).

1. Find the modules: top-level packages or folders with one responsibility (a Go package, a Python package, a
   PowerShell module). Small projects may have two or three; that is fine.
2. For each module, read its public surface (exported Go names, a Python package's public functions, a
   PowerShell module's exported functions), its callers and its tests.
3. Find the commands that build, test and lint, from build files, CI config, scripts or the README. Use only
   commands you found; do not make one up.
4. Read the existing rule files from the role map (README sections, CONTRIBUTING.md, CHANGELOG.md). Their rules
   go into the router by reference, not by copy.

If the module split is not obvious (one big package, or folders that call each other's internals), list the
split you would use in one short message and ask before writing.

## Step 2: write the files

Copy the templates from `../../templates/` and fill them. Delete the template's guidance comments and example
rows once replaced. Write in the project's language and examples, not the template's.

| File | Template | Where |
|---|---|---|
| Root router | `CLAUDE.root.md` | `CLAUDE.md` at the repo root, at most 150 lines |
| One per module | `CLAUDE.module.md` | `<module>/CLAUDE.md`, importing its contract with `@` |
| One contract per module | `contract.md` | `docs/contracts/<module>.md` |
| Decision log | `DECISIONS.md` | `DECISIONS.md` (or `docs/DECISIONS.md` if the project keeps docs there) |
| Progress | `PROGRESS.md` | `PROGRESS.md` |

Testing and release docs only where they fit: a short `TEST_CHECKLIST.md` when the project has manual checks
(UI, hardware, a measured run), a short `BUILD_AND_RELEASE.md` when it has release steps. Skip them otherwise.

Rules while writing:

- **Contracts describe what the code does today**, not what it should do. A bug you notice is written as current
  behaviour plus an open question, and reported; you do not fix it here.
- **Unclear points become open questions, never inventions.** When the code does not show a reason, a limit or
  an intent, write `Open question:` and the question in the section where it belongs, and list it in your
  report. Examples: "Open question: is the 30 s timeout a requirement or a guess?", "Open question: should
  `Load` accept an empty file?".
- **Every invariant names its test.** If no test covers it, write `Test: none yet` and add it to the contract's
  "Tests required" list. Do not write tests in this skill.
- **Decisions only from evidence.** The first entry is the decision to adopt this structure, with today's date
  and the owner's approval. Other entries only when a commit, a comment or a doc states the decision and its
  reason; cite the source. A choice you can see in the code but not the reason for goes in as an open
  question, not as a decision.
- **Do not change code** and do not edit the existing rule files. The new router points to them ("Development
  rules: README.md, section Development").
- **A router under another name stays.** If the project already has one (`AGENTS.md`, `GEMINI.md`,
  `.github/copilot-instructions.md`), never rename, move or merge it. Propose a short root `CLAUDE.md` that
  links to it, and write it only after the owner says yes to that specific file.
- **The router stays short.** It routes; details go in module files and contracts. Count the lines.

## Step 3: the owner reviews everything before commit

Do not commit. Report:

1. the files written, with line counts (the router's must be 150 or fewer);
2. the module split you used;
3. every open question, grouped by file;
4. anything in the code that looked like a bug, written as current behaviour.

Ask the owner to read the files and answer the open questions. Apply their corrections. Commit only when they
say so, with a message in the project's commit format (from the role map; Conventional Commits only when the
project has no rule). After that, run `jiance-stack:onboard-project` again so the role map points at the new
files.

## Common mistakes

| Mistake | Instead |
|---|---|
| Writing the router "to get started" before the owner answered | Approval check first; no yes, no file |
| Describing the design the code should have | Describe what it does today; the rest is open questions |
| Inventing a reason for a timeout, a limit or a format | `Open question:` in the contract, listed in the report |
| Copying the README's rules into CLAUDE.md | Link to them; the README stays the source |
| A 300-line router with every module's details | Route only; details go in module CLAUDE.md and contracts |
| Committing the new files with the setup | The owner reviews first, then says when to commit |
