# Upstream sources

Pins: superpowers `https://github.com/obra/superpowers` at `2ce8aa1`; pstack and thermos
`https://github.com/cursor/plugins` at `e73df47`.

| skill | upstream repo | path | commit | changes |
|---|---|---|---|---|
| hooks/run-hook.cmd | https://github.com/obra/superpowers | hooks/run-hook.cmd | 2ce8aa1 | Credit lines added; otherwise unchanged. Kept LF line endings, since bash parses it too. |
| hooks/session-start | https://github.com/obra/superpowers | hooks/session-start | 2ce8aa1 | Injects the jiance-stack:using-jiance router instead of using-superpowers; emits only the Claude Code JSON shape; warns when superpowers or pstack is installed; never exits non-zero. Keeps the $0 path split, builtin file read, JSON escaping and EPIPE-safe output. |
