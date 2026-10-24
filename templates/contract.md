# Contract: <module>

<!-- One per module, at docs/contracts/<module>.md, imported by <module>/CLAUDE.md. On an existing project it
describes what the code does today, not what it should do. Anything the code does not answer is written as
"Open question: ..." in the section where it belongs, never invented. Changing Public API, Behaviour or an
Invariant is a contract change and needs the owner's OK. Delete these comments and the examples once filled. -->

## Purpose

<One or two sentences: what this module is for and who calls it.>

## Owns

<What this module alone is responsible for: data, files, a protocol, a resource.>

- <the mapping from short code to long URL>
- <the on-disk file `links.json`>

## Does not own

<Nearby things that belong elsewhere, with the module that owns them. This is what stops scope creep.>

- <HTTP status codes: `api`>
- <URL validation: `api` validates before calling `Put`>

## Public API

<Every exported name other modules may use, with its signature. Anything not listed here is internal.>

```go
func New(path string) (*Store, error)
func (s *Store) Put(url string) (code string, err error)
func (s *Store) Get(code string) (url string, ok bool)
```

```python
def put(url: str) -> str: ...
def get(code: str) -> str | None: ...
```

## Behaviour

<What happens for normal input, edge cases and errors. One line per case.>

- <`Put` of a URL seen before returns the same code.>
- <`Get` of an unknown code returns `"", false`; it never returns an error.>
- <`New` on a missing file starts empty; on a corrupt file returns an error that names the path.>
- <Open question: should `Put` reject an empty URL, or is that `api`'s job only?>

## Invariants

<Things that are always true. Each one names the test that checks it, or "Test: none yet".>

| Invariant | Test |
|---|---|
| <The same URL always gets the same code.> | <`TestPutIsIdempotent`> |
| <Codes are exactly 7 base62 characters.> | <`TestCodeShape`> |
| <A saved store reloads to the same mapping.> | <Test: none yet> |

## Tests required

<Tests that must exist for this contract to be checked, including the missing ones from the table above.>

- <round trip: `New` after `Put` and close returns the same mapping (missing)>
- <concurrent `Put` of the same URL returns one code>

## Change notes

<Newest first. One line per contract change: date, what changed, the decision ID that approved it.>

- <YYYY-MM-DD: contract written from the code as it was (setup), D1.>
