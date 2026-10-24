# <project name>

<!-- Root router. It routes; it does not explain. Keep this file at 150 lines or fewer: every line here is
loaded into every session. Details belong in a module's CLAUDE.md and contract. Delete these comments and the
example rows once the file is filled. -->

<One or two sentences: what the project is and who uses it.>

## Where things are

Start here, then open only the module you work on: its `CLAUDE.md` loads its contract. Do not read another
module's internals; read its contract.

| Module | Path | Read first | Owns |
|---|---|---|---|
| <store> | `<store/>` | `<store/CLAUDE.md>` | <keeping links on disk> |
| <api> | `<api/>` | `<api/CLAUDE.md>` | <the HTTP handlers> |

Other docs:

- `DECISIONS.md`: decisions with reasons and rejected alternatives. Do not reopen a final decision silently.
- `PROGRESS.md`: what is done and what is next; the single source of truth for status.
- `<CHANGELOG.md>`: user-visible changes. <Delete the lines for docs the project does not have.>
- `<TEST_CHECKLIST.md>`: manual and measured checks that replace automated tests, each with its reason.
- `<Existing rule file, for example README.md section "Development">`: <what it holds>. It stays the source.

## How to work

1. Read this file, then the `CLAUDE.md` of the module you change, then the contracts of the modules it calls.
2. Changes that touch two or more modules, change a public contract or an invariant, or add a dependency need
   the owner's OK first: present a short plan and wait.
3. Every new behaviour gets a test that fails first; a bug fix gets a regression test when a sensible one
   exists. When an automated test would be a bad one, record the substitute and its reason in
   `<TEST_CHECKLIST.md or PROGRESS.md>`.
4. Run the commands below and paste their real output before saying anything works.
5. Update `PROGRESS.md` in the same commit as the work.
6. A contract change updates the contract and its "Change notes" in the same commit.

## Commands

<Only commands that exist in this project. One example per language below; keep the one that fits.>

```sh
# Go
go build ./...
go test ./...
go vet ./...

# Python
python -m pytest
ruff check .
```

```powershell
# PowerShell
Invoke-Pester -Path tests
Invoke-ScriptAnalyzer -Path . -Recurse
```

## Hard rules

<Rules every change must keep, each with its reason and the decision that set it. Five to ten lines. A rule
without a decision ID is a rule nobody can trace; add the decision or mark it as an open question.>

- <Codes are 7 characters, base62. Why: they appear in printed material and must stay short.> (<D2>)
- <No network access from `store`. Why: it must work offline and be testable without a server.> (<D4>)
- <No new dependency without the owner's OK and a size estimate. Why: every dependency
   is code nobody here controls.> (<D5>)

## Conventions

- Commits: <the project's format, for example Conventional Commits with the module as scope:
  `fix(store): ...`; or the project's own format such as `[store] message`>.
- Branches: <one branch per milestone, merged after the owner's OK>.
- Files: <focused files of about 300 lines; split by responsibility beyond that>.
- Encoding: <UTF-8 without BOM; ASCII-only source; English in code and docs>.
- <Anything else every change must follow: error wrapping, logging rules, naming.>

## Open questions

<Points the setup could not answer from the code, waiting for the owner. Delete the section when empty.>

- <Open question: is the 30 s client timeout a requirement or a default nobody chose?>
