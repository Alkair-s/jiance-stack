#!/usr/bin/env bash
# Builds a tiny Go module in the eval workspace (the current directory): an HTTP
# handler package that validates a note and a store package that persists it.
set -eu

mkdir -p handler store

cat > go.mod <<'GO'
module example.com/notes

go 1.22
GO

cat > main.go <<'GO'
package main

import (
	"log"
	"net/http"

	"example.com/notes/handler"
	"example.com/notes/store"
)

func main() {
	s := store.NewFileStore("notes.jsonl")
	mux := http.NewServeMux()
	mux.Handle("POST /notes", handler.NewSaveHandler(s))
	log.Fatal(http.ListenAndServe(":8080", mux))
}
GO

cat > handler/save.go <<'GO'
// Package handler turns HTTP requests into calls on a Saver.
package handler

import (
	"encoding/json"
	"net/http"
	"strings"
)

// Saver persists a note and returns its id.
type Saver interface {
	Save(title, body string) (string, error)
}

type saveRequest struct {
	Title string `json:"title"`
	Body  string `json:"body"`
}

// NewSaveHandler returns the handler for POST /notes.
func NewSaveHandler(s Saver) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var req saveRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, "bad json", http.StatusBadRequest)
			return
		}
		if strings.TrimSpace(req.Title) == "" {
			http.Error(w, "title required", http.StatusBadRequest)
			return
		}
		id, err := s.Save(req.Title, req.Body)
		if err != nil {
			http.Error(w, "save failed", http.StatusInternalServerError)
			return
		}
		w.WriteHeader(http.StatusCreated)
		json.NewEncoder(w).Encode(map[string]string{"id": id})
	})
}
GO

cat > store/file.go <<'GO'
// Package store persists notes to an append-only JSON lines file.
package store

import (
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"os"
	"sync"
)

// FileStore appends one JSON object per note to a file.
type FileStore struct {
	mu   sync.Mutex
	path string
}

type record struct {
	ID    string `json:"id"`
	Title string `json:"title"`
	Body  string `json:"body"`
}

// NewFileStore returns a store that writes to path.
func NewFileStore(path string) *FileStore {
	return &FileStore{path: path}
}

// Save appends the note under a lock and returns its random id. Concurrent
// requests are serialized so lines never interleave.
func (f *FileStore) Save(title, body string) (string, error) {
	id := newID()
	line, err := json.Marshal(record{ID: id, Title: title, Body: body})
	if err != nil {
		return "", err
	}
	f.mu.Lock()
	defer f.mu.Unlock()
	file, err := os.OpenFile(f.path, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0o600)
	if err != nil {
		return "", err
	}
	defer file.Close()
	if _, err := file.Write(append(line, '\n')); err != nil {
		return "", err
	}
	return id, nil
}

func newID() string {
	b := make([]byte, 8)
	_, _ = rand.Read(b)
	return hex.EncodeToString(b)
}
GO
