---
type: llm
focus: trace
weight: 1
---

Names the reader of the JSON field outside the diff and runs a script or test to prove it.

The staged change renames the `customer_id` key in `exporter/export.py` to `customer`. The Go file
`reports/monthly.go` reads the same `orders.json` with the struct tag `json:"customer_id"`, so after the change
Go's decoder leaves `CustomerID` empty and every total lands under the empty customer, silently and with no error.
It passes only when the final answer names `reports/monthly.go` (or its `customer_id` tag) as a reader outside the
diff and says what breaks there, and then does one of two things: (a) runs a script or test against the real code
and quotes its output, or (b) because the agent has no shell, gives the exact script or test that would prove the
fact (in Go, Python or both, calling the real code) and marks the fact as unproven, not proven. It fails when it
calls the rename safe, misses the Go reader, invents a reader that does not exist, or claims the breakage is proven
without a run whose output appears in the trace.
