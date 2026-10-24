# Case study: the method on Wall Rose

Wall Rose is a small Android app that shows where chosen apps connect and can block them, without root. It is
public: https://github.com/Alkair-s/Wall-Rose. It was built with Claude Code using the method that jiance-stack
packages. This page describes what that method looked like in practice and what the structure prevented.

## Three phases

1. **Planning brief.** Done in a separate chat, before any code. It fixed the goal, the limits and the things
   that must not be built.
2. **Technical document.** One document with the architecture, packet flow, threading, schemas and the measured
   performance targets. Claude Code reads only the section it needs.
3. **Milestones.** The work is split into milestones M0 to M8, from scaffolding through one module at a time to
   measuring, hardening and the first release. A milestone is done only when every box is ticked and its Verify
   command passes.

## Structure that keeps sessions small

- **A router `CLAUDE.md`.** About 90 lines. It lists where things are, the module table, how to work, the
  commands and the hard rules. Details live in `docs/`, not in this file.
- **One contract per module.** Each module has a contract with its purpose, public API, dependencies,
  invariants and required tests. The rule is to read the contract of the module you call, never its internals.
  A session loads one module instead of the whole codebase, and modules cannot grow hidden coupling.
- **A decision log.** Every decision has an ID, a reason and the alternatives that were rejected. Rejected
  decisions are listed so nobody builds them by accident.
- **A progress file.** `PROGRESS.md` is the source of truth for what is done and what is next. Each session
  starts there and updates it in the same commit as the work.

## Approval points

Claude stops and asks in three places. A change to a public contract needs approval, and the new contract text
is shown first. A change that touches two or more modules is planned in plan mode and approved before editing.
A new dependency needs approval and a size estimate. Security review findings went to the owner before any fix.

## Real output, not claims

The rule is to run the verification commands and report their output. A typical entry in the progress log says
that the full build, test and lint run succeeded with 299 tests and 0 failures, that the native-library check
exited 0, and that the release APK was 3 198 812 bytes. Without that output, nobody could tell "done" from
"probably done".

## Measured performance targets

The technical document gives each target a goal, a hard limit and a measuring method. Examples: release size at
most 5 MB, memory at most 80 MB with the tunnel running, added connect delay at most 10 ms at the 95th
percentile. The measured release came in at 3.2 MB, about 60 MB and under 10 ms. One target was missed on the
first run (idle wakeups). It was reported first, the causes were found by measuring per-thread wakeups, and then
it was fixed and measured again, rather than guessed at.

## Security review

Before the first release, the code was reviewed against a written list of security requirements. The review
found no critical issue, but it found real gaps: a blocked app could reuse a logged app's port, DNS answers were
accepted from the wrong source, a download had no total time limit, and log calls survived in the release build.
Each fix was written test-first, with the failing test seen before the fix.

## Test-first parsers

The packet parsers handle untrusted bytes, so they were written test first, with fixtures from real traffic and
a fuzz test of at least 100 000 random inputs. Parsers never throw across the module boundary. They return a
malformed result instead.

## What the structure prevented

- Sessions re-reading the whole codebase to change one module.
- Contract changes slipping in unannounced.
- A rejected idea being rebuilt in a later session because nobody remembered why it was rejected.
- "It works" claims with no output behind them.
- Performance work done by guessing.

jiance-stack turns these habits into skills and defaults, so a new project can start with them in place.
