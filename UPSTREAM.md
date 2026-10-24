# Upstream sources

Pins: superpowers `https://github.com/obra/superpowers` at `2ce8aa1`; pstack and thermos
`https://github.com/cursor/plugins` at `e73df47`.

| skill | upstream repo | path | commit | changes |
|---|---|---|---|---|
| hooks/run-hook.cmd | https://github.com/obra/superpowers | hooks/run-hook.cmd | 2ce8aa1 | Credit lines added; otherwise unchanged. Kept LF line endings, since bash parses it too. |
| hooks/session-start | https://github.com/obra/superpowers | hooks/session-start | 2ce8aa1 | Injects the jiance-stack:using-jiance router instead of using-superpowers; emits only the Claude Code JSON shape; warns when superpowers or pstack is installed; never exits non-zero. Keeps the $0 path split, builtin file read, JSON escaping and EPIPE-safe output. |
| testing | https://github.com/obra/superpowers | skills/test-driven-development | 2ce8aa1 | Primary source. Merged with pstack tdd into the jiance-stack testing rule (design 6.3): tests for every new feature, bad tests replaced by recorded substitutes with a written reason, evidence report, guardrails, a no-shell fallback. Dropped the "delete code written first" iron law and the dot graph; TypeScript examples replaced by Python and Go in references/examples.md. |
| testing | https://github.com/cursor/plugins | pstack/skills/tdd | e73df47 | Second source. Kept the steps (narrowest test, fail for the right reason, smallest fix, rerun), the bad-test list, the closest-real-check fallback, the guardrails and the evidence report; widened from bug fixes to every feature; removed disable-model-invocation. |
