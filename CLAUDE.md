# jiance-stack: instructions for Claude Code

A public, self-contained Claude Code plugin (skills, hooks, scripts, evals). It adapts skills from superpowers
(Jesse Vincent), pstack (Lauren Tan) and thermos (Cursor), all MIT, with explicit credit. Owner: Alkair-s.

<!-- Keep this file under ~150 lines. Details belong in docs/, not here. -->

## Where things are

- `docs/PROGRESS.md`: state file. What is done, what is next, every decision and parked item. Read it first.
- `docs/specs/2026-10-24-jiance-stack-design.md`: the approved design. The binding authority.
- `docs/plans/`: implementation plans, one per stage.
- `docs/EVALS.md`: how to write and run eval cases (read before touching `evals/`).
- `principles/defaults.md`: default principles P1-P14 that every project starts from.
- `config/models.md`: which model each subagent role uses.
- `skills/<name>/SKILL.md`: one skill per directory, flat (Claude Code discovers skills one level deep).
- `skills/using-jiance/SKILL.md`: the router, injected at session start by `hooks/session-start`.
- `templates/`: project templates used by `setup-structure`.
- `UPSTREAM.md`: one row per adapted file: source, path, commit, every behaviour change.
- `NOTICE`: the upstream MIT notices and the thank-you.

## How to work in this repo

1. Start of a session: read `docs/PROGRESS.md`; work on the first open item unless the owner says otherwise.
2. Follow the design. If it, a plan and PROGRESS disagree, do not pick one: tell the owner.
3. Use this plugin's own method on itself: brainstorm, plan, test first, review, verify with real output.
4. Approval points (stop and wait): new dependencies, changes to the design's rules or the default principles,
   anything published (push, tag, release), removing or weakening an approval point or a credit.
5. Update `docs/PROGRESS.md` in the same commit as the work (P13).

## Hard rules

- **Credit.** Every adapted file starts (right after its frontmatter) with one line per source, exactly like
  `> Adapted from obra/superpowers` + path in backticks + `at` + short sha in backticks + `by Jesse Vincent, MIT
  License. See NOTICE and UPSTREAM.md.` (copy the line from `skills/brainstorming/SKILL.md:6` as the model).
  Scripts and HTML carry the same text as a comment. Pins in use: obra/superpowers `2ce8aa1`,
  cursor/plugins (pstack, thermos) `e73df47`. Never copy from the community pstack port.
- **UPSTREAM.md.** Every behaviour change beyond the adaptation rules goes in that file's row. "Otherwise
  unchanged" only when it is true. Reviewers check this.
- **Adaptation rules** for any copied skill:
  - cross-references become `jiance-stack:<skill>`; superpowers TDD and pstack `tdd` become `jiance-stack:testing`;
  - Cursor mechanics (Task tool, `readonly`, `pstack-models.mdc`, model slugs, `generalPurpose`) become the Agent
    tool: `Explore` for read-only excerpt search, `general-purpose` when the subagent must read whole files or use
    MCP tools; models come from `config/models.md` roles;
  - remove `disable-model-invocation: true` (the router must call them), except for skills meant to be manual;
  - plan and review steps mention the approval points and the helper gate;
  - plugin files are referenced relative to the skill directory (`../../config/models.md`).
- **Subagents.** Every skill that spawns subagents says "Invoking this skill is asking for subagents". Claude
  Code's own prompt otherwise discourages spawning, and the skill silently runs inline.
- **Models.** Only `opus` and `sonnet` roles (Opus 5.5 / Sonnet 5.5 or newer). Never `haiku` or pinned old IDs.
- **Encoding (P3).** English only. UTF-8 without BOM. Scripts, JSON and `.cmd` are ASCII only. Markdown may use
  Unicode, never an em dash. `scripts/check-encoding.sh` must exit 0.
- **unslop** stays exactly as upstream (owner's decision). Parentheses in this repo's own files are fine.
- **Examples** are language-agnostic, or Python, Go or PowerShell. Kotlin only next to one of those.
- **No personal details** in tracked files: no device names, local paths, emails, names other than upstream
  authors and the `Alkair-s` handle.
- **Files** about 300 lines at most; move detail into `references/`.
- **Commits.** Conventional Commits with the area as scope (`feat(skills): ...`, `fix(router): ...`,
  `docs(progress): ...`), ending with the `Co-Authored-By` line. One branch per stage; merge after the owner's OK.

## Commands

Run from the repo root in Git Bash.

- All script tests: `bash tests/run.sh`
- Skill frontmatter and credit lines: `scripts/validate-skills.sh skills`
- Encoding: `scripts/check-encoding.sh`
- Plugin manifest and skills: `claude plugin validate --strict .`
- Leftover upstream references (must print nothing): `git grep -n 'superpowers:' -- skills`
- Evals: see `docs/EVALS.md` (they cost usage; run one case at a time while iterating).

## Gotchas

- `hooks/run-hook.cmd` stays LF (bash also parses it); `.gitattributes` overrides the `*.cmd` CRLF rule for it.
- `scripts/validate-skills.sh` treats UPSTREAM.md rows containing `/` as file paths (for hooks and scripts).
- The session-start hook must always exit 0 and must work with an empty PATH (`tests/session-start.test.sh`).
- When the owner's usage limit is near, prefer fewer eval runs over skipping the task review.
