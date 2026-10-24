# jiance-stack

jiance-stack is a self-contained Claude Code plugin for disciplined AI coding. The name comes from the Chinese
word 检测工具 (jiǎncè gōngjù), "inspection tool": inspect, test, prove. It gives Claude a router that picks the
right working style for the task, a set of skills for planning, testing, debugging and review, and a set of
default engineering principles. It is adapted from superpowers and pstack, and it does not need either of them.

## Status

Stage 1 is version 0.1.0: the existing-project area and the core general skills. Stage 2, the new-project
area, is planned.

## What is in it

The router skill `using-jiance` is injected at the start of every session. It picks one of three areas and says
which skill to run first.

**Existing project.** Adapt to the structure a project already has, without editing it.

- `onboard-project`: find the project's rules and structure and follow them.
- `change-request`: take a fix, a feature or new tests from understanding to verified change.
- `setup-structure`: add the jiance-stack structure, only after the owner approves.
- `helper-gate`: check that a new helper is needed before it is added.
- `evaluate-principles`: explain and review a project's principles; suggests only.
- `blast-radius`: find what a change could break elsewhere.
- `how`, `why`, `teach`: explain how code works, why it is this way, and teach it plainly.

**New project.** Planned for stage 2.

**General.** Skills that work anywhere.

- `brainstorming`, `writing-plans`, `executing-plans`, `subagent-driven-development`
- `testing`, `systematic-debugging`, `verification-before-completion`
- `requesting-code-review`, `receiving-code-review`, `interrogate`, `thermo-nuclear-review`
- `using-git-worktrees`, `finishing-a-development-branch`
- `unslop`: cut AI tells from writing

A worked example of the method is in [docs/case-study.md](docs/case-study.md).

## Requirements

- Claude Code 2.1.310 or newer.
- On Windows, Git Bash, because the session-start hook runs under it.
- Node.js is optional. Only the brainstorming visual companion uses it.

## Install

```
/plugin marketplace add Alkair-s/jiance-stack
/plugin install jiance-stack@jiance-stack
```

Then start a new session.

## Disable superpowers and pstack

jiance-stack replaces them. If they are enabled at the same time, two routers and two copies of the same skills
compete, and Claude may follow either one. The session-start hook prints a warning when it finds them.
Disable both and keep only jiance-stack.

## Default principles and overrides

[principles/defaults.md](principles/defaults.md) lists the defaults (P1 to P14), each with its reason: fewest
dependencies, English and ASCII source, real command output, tests for every feature, measured performance,
small focused files and more. On an existing project they apply only where the project's own rules are silent.
Precedence is the owner's instructions, then the project's rules, then these defaults, then individual skills.
A project overrides a default only with a dated entry in its own decision log that names the rule and the
reason.

## Models

[config/models.md](config/models.md) is the only place that names models. Skills that spawn subagents read it to
pick a role (reviewer, explorer, implementer and so on). It allows only the `opus` and `sonnet` aliases, so the
newest of each is used. A project can override roles with a `## Models` section in its own `CLAUDE.md`.

## How behaviour is checked

- Plain Bash tests: `bash tests/run.sh`.
- Skill structure: `scripts/validate-skills.sh skills`.
- Encoding rules (ASCII source, no BOM, no em dashes in docs): `scripts/check-encoding.sh`.
- Manifest: `claude plugin validate --strict .`.
- Behaviour: `claude plugin eval` cases, each run with the plugin and against a no-plugin baseline, so the
  difference the plugin makes is measured. On Windows the evals run without a shell tool, so the cases judge
  transcripts.

## Known limits

- Skills that spawn subagents say explicitly that invoking them is a request for subagents. Claude Code's own
  prompt otherwise discourages spawning, and the skill would stall.
- The new-project area does not exist yet.

## Credits

jiance-stack stands on the work of others, and we owe them a lot for the effort they put into it. Thank you.

- Jesse Vincent, for [superpowers](https://github.com/obra/superpowers). The planning, testing, debugging,
  review and worktree skills, and the session-start hook, are adapted from it.
- Lauren Tan, for pstack, and Cursor, for pstack and thermos, both in
  [cursor/plugins](https://github.com/cursor/plugins). `how`, `why`, `teach`, `interrogate`, `blast-radius`,
  `thermo-nuclear-review`, `unslop` and parts of `testing` come from there. The community Claude Code port of
  pstack was not copied.

All three are MIT licensed. [NOTICE](NOTICE) holds their full license texts, each adapted skill begins with a
credit line, and [UPSTREAM.md](UPSTREAM.md) records the source path, pinned commit and changes for each one.

## License

MIT. See [LICENSE](LICENSE).
