# "Cannot Verify From Diff" Items

> Adapted from obra/superpowers `skills/subagent-driven-development/references/cannot-verify.md` at `2ce8aa1` by Jesse Vincent, MIT License. See NOTICE and UPSTREAM.md.

Part of jiance-stack:subagent-driven-development.

The task reviewer may report "WARN Cannot verify from diff" items - requirements
that live in unchanged code or span tasks. These do not block the rest of the
review, but you must resolve each one yourself before marking the task
complete: you hold the plan and cross-task context the reviewer
lacks. If you confirm an item is a real gap, treat it as a failed spec
review - it enters the fix loop with the other findings.
