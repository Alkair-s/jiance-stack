#!/usr/bin/env bash
# Builds a small Go link-shortener that already has the full structure: a root
# router CLAUDE.md, one contract per module under docs/contracts/, and a
# PROGRESS.md whose rule says to update it in the same commit as the work.
set -eu

mkdir -p docs/contracts store api

cat > CLAUDE.md <<'MD'
# shortlink

A small HTTP service that turns long URLs into short codes.

## Where things are

| Module | Code | Contract |
|---|---|---|
| store | `store/` | `docs/contracts/store.md` |
| api | `api/` | `docs/contracts/api.md` |

Read the contract of a module before you change or call it. Do not read another module's internals.

## How to work

- Every change updates `PROGRESS.md` in the same commit (append to the log, newest first).
- Run `go test ./...` before you say a change works, and paste the output.

## Hard rules

- Codes are 7 characters, base62. Changing that is a contract change and needs the owner's OK.
- No new dependencies without asking.
MD

cat > docs/contracts/store.md <<'MD'
# Contract: store

## Purpose
Keeps the mapping from short code to long URL in memory.

## Public API
- `func (s *Store) Put(url string) (code string, err error)`
- `func (s *Store) Get(code string) (url string, ok bool)`

## Invariants
- The same URL always gets the same code. Test: `TestPutIsIdempotent`.
MD

cat > docs/contracts/api.md <<'MD'
# Contract: api

## Purpose
HTTP handlers: `POST /links` creates a code, `GET /{code}` redirects.

## Behaviour
- Unknown code returns 404, never 500. Test: `TestUnknownCode404`.
MD

cat > PROGRESS.md <<'MD'
# Progress

Single source of truth for what is done. Update it in the same commit as the work.

## Log (newest first)

- 2026-10-20: api handlers and tests done; `go test ./...` passes.
- 2026-10-18: store with idempotent Put.
MD

cat > go.mod <<'GO'
module example.com/shortlink

go 1.23
GO

cat > store/store.go <<'GO'
package store

import "sync"

// Store maps short codes to long URLs.
type Store struct {
	mu    sync.Mutex
	byURL map[string]string
	byKey map[string]string
}

// New returns an empty Store.
func New() *Store {
	return &Store{byURL: map[string]string{}, byKey: map[string]string{}}
}

// Put returns the code for url, creating one when needed.
func (s *Store) Put(url string) (string, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if code, ok := s.byURL[url]; ok {
		return code, nil
	}
	code := encode(len(s.byKey) + 1)
	s.byURL[url] = code
	s.byKey[code] = url
	return code, nil
}

// Get returns the URL for code.
func (s *Store) Get(code string) (string, bool) {
	s.mu.Lock()
	defer s.mu.Unlock()
	url, ok := s.byKey[code]
	return url, ok
}

func encode(n int) string {
	const alphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	out := []byte("0000000")
	for i := 6; i >= 0 && n > 0; i-- {
		out[i] = alphabet[n%62]
		n /= 62
	}
	return string(out)
}
GO

cat > api/api.go <<'GO'
package api

import (
	"net/http"

	"example.com/shortlink/store"
)

// Handler serves the shortlink HTTP API.
func Handler(s *store.Store) http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /{code}", func(w http.ResponseWriter, r *http.Request) {
		url, ok := s.Get(r.PathValue("code"))
		if !ok {
			http.NotFound(w, r)
			return
		}
		http.Redirect(w, r, url, http.StatusFound)
	})
	return mux
}
GO
