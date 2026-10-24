---
type: llm
focus: trace
weight: 1
---

Explains the flow handler to store with file:line references, puts the depth on the store, does not edit files.

It passes when the final answer walks the request from the handler (`handler/save.go`, the decode, the title
check, the call to `Save`) into the store (`store/file.go`, the lock, the append, the generated id) with file and
line references (for example `handler/save.go:30` or `store/file.go:41`), spends most of its words on the store
because the user is about to change it (locking, append-only file, id generation, error returns), and the trace
shows no Write or Edit call. It fails when it edits any file, gives no file references, or treats both packages
with equal weight and little store detail.
