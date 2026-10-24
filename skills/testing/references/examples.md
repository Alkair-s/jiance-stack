# Testing examples

Worked examples for `jiance-stack:testing`. Each shows the same loop: narrowest test, failing run quoted,
smallest change, passing run quoted. Outputs are trimmed to the lines a report should quote.

## Language-agnostic shape

1. Pick one behaviour and one hand-checked example: input `"10MB"`, expected output `10000000`.
2. Write a test that calls the real function with that input and compares with the literal.
3. Run only that test. Expected: it fails, and the message shows the behaviour is missing (wrong value or
   missing name), not a broken test.
4. Write the smallest code that returns the right value for the cases the tests name.
5. Run that test, then the project's full suite. Quote both.

## Python (pytest): new feature

Test first, in `tests/test_units.py`:

```python
import pytest

from sizes.units import parse_size


@pytest.mark.parametrize("text, expected", [
    ("10MB", 10_000_000),
    ("1.5KB", 1_500),
    ("42B", 42),
])
def test_parse_size(text, expected):
    assert parse_size(text) == expected


def test_parse_size_rejects_garbage():
    with pytest.raises(ValueError):
        parse_size("ten megabytes")
```

First run fails on the missing name. Add a stub `def parse_size(text: str) -> int: return 0` and run again so the
assertion itself is shown failing:

```text
$ python -m pytest tests/test_units.py -k parse_size
FAILED tests/test_units.py::test_parse_size[10MB-10000000] - assert 0 == 10000000
FAILED tests/test_units.py::test_parse_size_rejects_garbage - Failed: DID NOT RAISE <class 'ValueError'>
4 failed in 0.03s
```

Smallest change, in `sizes/units.py`:

```python
_FACTORS = {"B": 1, "KB": 1000, "MB": 1000**2, "GB": 1000**3, "TB": 1000**4}


def parse_size(text: str) -> int:
    """Return the number of bytes in text such as '10MB' (decimal units)."""
    s = text.strip().upper()
    for unit in sorted(_FACTORS, key=len, reverse=True):
        if s.endswith(unit):
            number = s[: -len(unit)].strip()
            try:
                return int(float(number) * _FACTORS[unit])
            except ValueError:
                break
    raise ValueError(f"cannot parse size: {text!r}")
```

Passing run, then the suite:

```text
$ python -m pytest tests/test_units.py -k parse_size
4 passed, 3 deselected in 0.02s
$ python -m pytest
7 passed in 0.03s
```

## Go (`go test`): bug fix with a regression test

Bug: `ParseSize("1.5KB")` returns 1000 because the number is truncated before multiplying.

Regression test first, in `sizes/size_test.go`, table-driven with literal expectations:

```go
func TestParseSize(t *testing.T) {
	tests := []struct {
		in   string
		want int64
	}{
		{"10MB", 10_000_000},
		{"1.5KB", 1_500},
		{"42B", 42},
	}
	for _, tt := range tests {
		got, err := ParseSize(tt.in)
		if err != nil || got != tt.want {
			t.Errorf("ParseSize(%q) = %d, %v; want %d, nil", tt.in, got, err, tt.want)
		}
	}
}
```

Failing run, for the right reason (the bug, not a compile error):

```text
$ go test ./sizes -run TestParseSize
--- FAIL: TestParseSize (0.00s)
    size_test.go:17: ParseSize("1.5KB") = 1000, <nil>; want 1500, nil
FAIL
```

Smallest fix: parse the number as a float, multiply, then convert. Passing run, then the suite:

```text
$ go test ./sizes -run TestParseSize
ok      example.com/units/sizes 0.004s
$ go test ./...
ok      example.com/units/sizes 0.005s
```

## Substitute instead of a bad test

Change: the page heading font size in a stylesheet. A test asserting the CSS value only repeats the source (it mirrors
the implementation) and there is no visual test harness, so the check is a checklist item. Recorded in
`docs/test-checklist.md`:

```markdown
- [ ] Page heading renders at the new size on the home page (open the page, inspect the heading).
  Why manual: an automated test would only repeat the CSS value; no visual test harness in this project.
```

Reply line: "No automated test: a test of the CSS value would only mirror the source. Substitute: checklist item in
docs/test-checklist.md, with the reason written there."
