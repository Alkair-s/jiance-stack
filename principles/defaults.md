# Default principles

These are the jiance-stack defaults. Each rule has an ID, the rule and its reason. New projects get a copy in their
own docs. On existing projects they apply where the project's own rules are silent.

| ID | Rule | Why |
|---|---|---|
| P1 | Fewest dependencies possible. When one is reasonably needed: newest stable, safest, not deprecated, no relocated or empty-shim artifacts, no known vulnerabilities (OSV.dev), transitive dependencies included. | Every dependency is code you do not control, so each one adds maintenance and security risk. |
| P2 | No new dependency without the owner's approval and a size estimate. | The owner decides what the project depends on, and needs the cost in front of them to decide. |
| P3 | English only for docs and code. UTF-8 without BOM. Source code is ASCII only; non-ASCII user-visible text lives in resource or translation files. Docs may use Unicode, but never em dashes. | Plain ASCII source and one language keep files portable across tools, editors and platforms. |
| P4 | Report real command output, never claims or assumptions. | The owner can only trust a result that is backed by output they can see. |
| P5 | Build modular, scalable and safe. | Cheap structure choices made early are expensive to fix later. |
| P6 | Every rule carries its reason. Decisions are logged with rejected alternatives; nothing is re-decided silently. New evidence goes to the owner, and work stops. | A rule without a reason cannot be judged or updated, and silent reversals destroy trust in the decision log. |
| P7 | Modules talk only through their contracts. Read the contract of a module you call, never its internals. Public contract changes need approval. A short root `CLAUDE.md` routes to one `CLAUDE.md` + contract per module. | Reading contracts instead of internals saves context and keeps modules replaceable. |
| P8 | Minimal changes. No features, options or abstractions "for completeness". New helpers pass the new-helper gate. | Code that was not asked for still has to be read, tested and maintained. |
| P9 | The testing rule: every new feature gets tests, bug fixes get a regression test when a sensible one exists, and a bad test is replaced on purpose by a recorded substitute with a written reason. Full rule: skill `jiance-stack:testing`. | Tests are the proof that behaviour works, and skipping one silently hides that nothing proves it. |
| P10 | Measure, don't guess. Performance targets have a target, a hard limit and a measuring method; misses are reported before optimizing. | Optimizing without numbers wastes effort and can make things worse. |
| P11 | Safe defaults: fail closed; never log secrets, payloads or user data; no telemetry unless the project decides it. | A leak or an open failure is far harder to undo than a closed default is to relax. |
| P12 | Never reason about code that has not been opened. Fix root causes, not symptoms. | Guesses about unread code are often wrong, and a symptom fix leaves the cause to return. |
| P13 | Progress is updated in the same commit as the work. Commits follow Conventional Commits with the module as scope (`fix(relay): ...`; breaking contract changes `feat(packet)!:` plus a `BREAKING CHANGE:` footer; releases `chore(release): vX.Y.Z`). One branch per milestone, merged after the owner's OK. | History and progress notes stay in step with the code, and the owner controls what reaches the main branch. |
| P14 | Focused files of about 300 lines; split by responsibility beyond that. | Small focused files are quicker to read and cost less context. |

## Overrides

A project overrides a default only with a dated entry in its own decision log that names the rule and gives the
reason. Example: "D12 overrides P14: generated parser files may exceed 300 lines, because they are regenerated,
never edited by hand." The plugin honours only written overrides. An unwritten preference, or a rule that was
simply ignored, is not an override.

## Precedence

When rules conflict, the order is: 1. The owner's direct instructions. 2. The project's own rules (CLAUDE.md, contracts, principles, decision log, written overrides). 3. jiance-stack defaults (principles/defaults.md). 4. Individual skill instructions.

## Enforcement as structure

P3 is enforced by `scripts/check-encoding.sh`. It fails on non-ASCII bytes in source files, a BOM in any text
file, or an em dash in docs. New projects get it through the templates, and this plugin runs it on itself.
