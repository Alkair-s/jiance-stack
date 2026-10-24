# Model roles

Skills that spawn subagents read this file to pick the model for each role. It is the only place that names models.

| role | model alias | why |
|---|---|---|
| reviewer-a | opus | Strongest reasoning for the first independent review angle. |
| reviewer-b | sonnet | A different model gives a different view, which is the point of a second reviewer. |
| explorer | sonnet | Read-only searching is fast and cheap, and needs no deep reasoning. |
| explainer | opus | Explaining a design or a diff to the owner needs the clearest reasoning. |
| implementer | sonnet | Well-specified implementation work is done well and economically by Sonnet. |
| final-reviewer | opus | The last review of a whole branch gets the strongest model. |
| helper-gate-reviewer | sonnet | The new-helper gate is a focused check: needed, not needed or unsure. |

## Rule

Use only the `opus` or `sonnet` aliases. They resolve to the newest Opus and Sonnet the account has, which is Opus 5.5
and Sonnet 5.5 or newer today. Pinned older model IDs and `haiku` are not allowed.

## Reviewer angles

Multi-reviewer skills mix the two models and give each reviewer a different angle:

- correctness
- security
- performance
- scalability
- maintainability

## Project override

A project overrides this file with a `## Models` section in its own `CLAUDE.md`, using the same
`role | model alias | why` table. Roles it does not list keep the defaults above. The same rule applies: only
`opus` or `sonnet`.

## Open item

O1: reviewers from other vendors may be added later to `interrogate`. When that happens, only this file changes.
