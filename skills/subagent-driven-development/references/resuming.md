# Resuming From an Existing Ledger

> Adapted from obra/superpowers `skills/subagent-driven-development/references/resuming.md` at `2ce8aa1` by Jesse Vincent, MIT License. See NOTICE and UPSTREAM.md.

Part of jiance-stack:subagent-driven-development. This plan's workspace
already has a ledger at `<workspace>/progress.md`.

If the ledger's first line names your plan file, tasks with a `Task <N>:
complete` line are DONE - do not re-dispatch them; resume at the first
task without one. A task whose last line is a fix round is mid-loop:
resume the loop at the next round. A ledger whose first line names a
different plan file - or a stray ledger at the old flat path
`.jiance-stack/sdd/progress.md` - is another plan's progress: leave it in
place and start your own, fresh.
