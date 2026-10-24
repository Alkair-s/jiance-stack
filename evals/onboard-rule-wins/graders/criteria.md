---
type: llm
focus: last_message
weight: 1
---

Uses the project's `[module] message` commit format and mentions the conflict with the default once.

It passes only when all of these hold. The proposed commit message's subject line follows CONTRIBUTING.md:
it starts with `[retry]` followed by a lower-case imperative message with no trailing period (for example
`[retry] raise default delay to 5 seconds`). It is not in Conventional Commits form (no `fix(retry):`,
`chore:` or similar prefix). The answer says once, briefly, that the project's format is used instead of a
default or Conventional Commits format (a mention such as "CONTRIBUTING.md asks for `[module] message`, so I
used that instead of Conventional Commits"). It mentions this conflict one time, not repeatedly. It fails when
the subject uses another format, or when the answer does not mention that the project's rule replaced a
different default format.
