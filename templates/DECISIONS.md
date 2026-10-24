# Decisions

<!-- The project's decision log. Every decision carries its reason and the alternatives that were rejected, so
nobody reopens it by accident. A final decision changes only through a new entry that supersedes it; new
evidence goes to the owner first. On an existing project, record only decisions with evidence (a commit, a
comment, a doc); a choice whose reason is unknown is an open question, not a decision. Delete these comments
and the examples once filled. -->

How to add one: take the next ID, write the date, the decision, why, and what was rejected and why. Hard rules
in `CLAUDE.md` cite these IDs.

An entry can override a jiance-stack default only by naming it and giving the reason, for example "overrides
P14".

## Final

### D1: <Adopt the router, module CLAUDE.md and contract structure> (<YYYY-MM-DD>)

- **Decision:** <A root CLAUDE.md routes to one CLAUDE.md plus contract per module; DECISIONS.md and
  PROGRESS.md hold decisions and status.>
- **Why:** <An agent loads one module's contract instead of the whole codebase, which saves context and keeps
  modules replaceable.>
- **Rejected:** <One large CLAUDE.md with everything: it is loaded every session and goes stale.>
- **Source:** <approved by the owner in the setup session.>

### D2: <Wrap every returned error with context> (<YYYY-MM-DD>)

- **Decision:** <Errors are returned as `fmt.Errorf("load %s: %w", path, err)`, never bare.>
- **Why:** <A bare error does not say where it came from.>
- **Rejected:** <Logging at each level: duplicates lines and leaks paths into logs.>
- **Source:** <commit `abc1234`, review comment in `store/load.go`.>

## Rejected

<Ideas considered and turned down, so they are not proposed again without new evidence.>

- <R1 (YYYY-MM-DD): a database instead of a JSON file. Rejected: one user, a few thousand links; a file is
  enough and needs no server.>

## Superseded

<Final decisions replaced by a later one. Keep them; say which entry replaced them. Delete if empty.>

- <D3 superseded by D7 (YYYY-MM-DD): codes grew from 6 to 7 characters.>
