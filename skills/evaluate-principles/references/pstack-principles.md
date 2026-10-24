> Summarized from cursor/plugins `pstack/skills/principle-*` at `e73df47` by Lauren Tan (summary, not a copy), MIT License. See NOTICE and UPSTREAM.md.

# pstack principles, one line each

A checklist for the "gaps" column of `jiance-stack:evaluate-principles`. Each line names a pstack principle and
says in one sentence what it asks for. They are a source of questions, not rules this plugin imposes: a gap is
worth raising only when the project's own code shows the problem the principle prevents.

| pstack principle | What it asks for |
|---|---|
| attack-the-premise | After two fixes built on one premise fail the same check, test the premise itself. |
| boundary-discipline | Validate at the system edges (CLI, config, network, external APIs); keep the core pure and trusting. |
| build-the-lever | Build the script, codemod or generator that does or proves the work, so a reviewer can rerun it. |
| encode-lessons-in-structure | A rule that keeps being repeated becomes a lint, check or script instead of more text. |
| exhaust-the-design-space | For a decision with no precedent, compare two or three prototypes before choosing. |
| experience-first | In scope trade-offs, prefer fewer polished features to more rough ones. |
| explain-the-number | Before trusting a measured number, find what limits it and that it measured the right thing. |
| fix-root-causes | Fix the first place the system went wrong, not where the symptom shows. |
| foundational-thinking | Choose the core types and data structures before writing logic. |
| guard-the-context-window | Keep bulk output out of the main thread; pass summaries. |
| laziness-protocol | Prefer deletion and the smallest change that solves the problem. |
| make-operations-idempotent | Steps that can be retried end in the same state however often they run. |
| migrate-callers-then-delete-legacy-apis | Move callers to a new internal API and delete the old one in the same change. |
| minimize-reader-load | Fewer layers between a question and its answer; less hidden mutable state. |
| model-the-domain | Name the domain's states and types instead of branching on raw shapes. |
| never-block-on-the-human | Do not ask permission for reversible work. jiance-stack keeps its owner approval points. |
| outcome-oriented-execution | In a planned migration, aim for the target design, not throwaway in-between states. |
| prove-it-works | Check the real result, not a proxy; script the check when possible. |
| redesign-from-first-principles | Fit a new requirement by rethinking the design, not by bolting it on. |
| separate-before-serializing-shared-state | Remove shared writable state before adding locks around it. |
| sequence-verifiable-units | Split work into small steps that each end in a state you can check. |
| subtract-before-you-add | Remove dead code and redundant checks before building on top. |
| test-behavior-not-implementation | Tests assert what users of the code can observe, not its internals. |
| type-system-discipline | Make illegal states unrepresentable; parse external data at the boundary. |

Overlap with `../../../principles/defaults.md`: fix-root-causes is P12, prove-it-works is P4, laziness-protocol
and subtract-before-you-add are close to P8, test-behavior-not-implementation feeds P9, encode-lessons-in-structure
is the "Enforcement as structure" section. never-block-on-the-human conflicts with P2, P6 and the owner's approval
points; in jiance-stack the approval points win, because pstack principles are not part of its precedence.
