# The Pre-flight Scan

Part of jiance-stack:subagent-driven-development. Run it once, before
dispatching Task 1.

Before dispatching Task 1, scan the plan once for conflicts, writing down
what you checked as you check it:

- tasks that contradict each other or the plan's Global Constraints
- anything the plan explicitly mandates that the review rubric treats as a
  defect (a test that asserts nothing, verbatim duplication of a logic block)

The scan's output is a table, not a verdict. One row for every pair of tasks
that share a file or an interface: the two tasks, what one produces against
what the other consumes, and what you found. One row for every task: whether
its own text agrees with itself - the tests it specifies against the code it
specifies, the files it creates against the files it later touches. "The scan
is clean" without those rows is not a scan you ran.

Write the table to the ledger. Rule on everything you find before execution
begins - each finding against the plan text that mandates it - and record
each ruling in the ledger. If the scan is clean, proceed without comment.
Rule on each conflict it surfaces - the spec is the binding authority, the
plan is its argument - record the ruling beside its row, and dispatch
Task 1. The review loop remains the net for conflicts that only emerge from
implementation.

Two more things the scan covers:

- **Approval points.** Every task that adds a dependency, changes a public contract, touches two or more modules or
  edits the project's own docs must be marked "Approval point" in the plan. A task that hits one and is not marked
  is a plan defect: ledger it as a row, mark it in your dispatch, and stop at it for the owner. This is never a
  ruling you make for the owner.
- **New helpers.** One row per task: its "New helpers" list. A task whose steps create a helper that no list
  names is a row too: the implementer will run `jiance-stack:helper-gate` before writing it.
