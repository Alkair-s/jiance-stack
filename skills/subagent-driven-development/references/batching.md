# Batching Small Same-Shape Work

> Adapted from obra/superpowers `skills/subagent-driven-development/references/batching.md` at `2ce8aa1` by Jesse Vincent, MIT License. See NOTICE and UPSTREAM.md.

Part of jiance-stack:subagent-driven-development.

**Batch small same-shape work.** When the plan lists several tasks that are
each a small, independent edit of the same kind - the same one-line fix,
constant change, or field addition repeated across files - do not dispatch
one subagent per task. Compose ONE dispatch brief listing every file and
its change, send the whole batch to a single subagent, and review its diff
as one unit. Reserve one-dispatch-per-task for work that needs its own
judgment, its own tests, or its own review surface.
