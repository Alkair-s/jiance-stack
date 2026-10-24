# Progress

<!-- The single source of truth for what is done. Update it in the same commit as the work. A box is ticked
only when its Verify command ran and passed, with the output pasted into the log. Delete these comments and
the examples once filled. -->

## How to run a milestone

1. Read `CLAUDE.md`, then the module files and contracts the milestone touches.
2. Write a plan for the milestone and get the owner's OK before any code.
3. Work task by task. Each new behaviour gets a test that fails first, then passes; a bad test is replaced by a
   recorded substitute with its reason in the test checklist or the log.
4. Run every item's Verify command. Paste the real output into the log. Tick the box only when it passed.
5. Update this file in the same commit as the work. Fill in "Next session must know".
6. Merge the milestone branch only after the owner's OK.

## Current state

<One paragraph: what works today, measured or checked, and what does not. On an existing project, written from
the code and the test run at setup time.>

## Next session must know

<One to three lines: the state a new session cannot guess. Replace, do not append.>

- <M2 task 3 is half done: `store` writes the file, reload is not wired yet.>

## Milestones

### M1: <Structure in place>

- [x] <Router, module CLAUDE.md files and contracts written from the code.>
  Verify: `<owner reviewed the files; open questions answered>`
- [ ] <Every invariant in the contracts has a test or a recorded substitute.>
  Verify: `<go test ./...>`

### M2: <Persist links to disk>

- [ ] <`New(path)` loads an existing file; a corrupt file returns an error naming the path.>
  Verify: `<go test ./store/... -run TestLoad>`
- [ ] <Round trip: put, close, reopen, get.>
  Verify: `<go test ./store/... -run TestRoundTrip>`
- [ ] <Manual: the service restarts with its links intact.>
  Verify: `<TEST_CHECKLIST.md item 3, result recorded below>`

## Log

<Newest first. Date, what was done, the Verify output or where it is, and anything left open.>

- <YYYY-MM-DD: M1 item 1 done. Files reviewed by the owner; 2 open questions answered, 1 moved to D3.>
- <YYYY-MM-DD: setup. `go test ./...` output: `ok example.com/shortlink/store 0.012s`.>
