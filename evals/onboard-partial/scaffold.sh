#!/usr/bin/env bash
# Builds a small Go CLI with partial structure: a README.md with working rules
# and a CHANGELOG.md, but no CLAUDE.md, no contracts, no decision log and no
# progress file.
set -eu

mkdir -p cmd/csvtrim trim

cat > README.md <<'MD'
# csvtrim

Trims whitespace from every cell of a CSV file.

    csvtrim input.csv > output.csv

## Development

- Run `go test ./...` before every commit.
- Every user-visible change gets an entry under `## Unreleased` in CHANGELOG.md, in the same commit.
- Keep the `trim` package free of I/O: it takes and returns `[][]string`; reading and writing files belongs
  in `cmd/csvtrim`.
MD

cat > CHANGELOG.md <<'MD'
# Changelog

## Unreleased

## 0.2.0

- Trim cells in quoted fields too.

## 0.1.0

- First release.
MD

cat > go.mod <<'GO'
module example.com/csvtrim

go 1.23
GO

cat > trim/trim.go <<'GO'
package trim

import "strings"

// Rows returns a copy of rows with every cell trimmed.
func Rows(rows [][]string) [][]string {
	out := make([][]string, len(rows))
	for i, row := range rows {
		out[i] = make([]string, len(row))
		for j, cell := range row {
			out[i][j] = strings.TrimSpace(cell)
		}
	}
	return out
}
GO

cat > trim/trim_test.go <<'GO'
package trim

import "testing"

func TestRowsTrimsCells(t *testing.T) {
	got := Rows([][]string{{" a ", "b "}})
	if got[0][0] != "a" || got[0][1] != "b" {
		t.Fatalf("got %q", got)
	}
}
GO

cat > cmd/csvtrim/main.go <<'GO'
package main

import (
	"encoding/csv"
	"log"
	"os"

	"example.com/csvtrim/trim"
)

func main() {
	if len(os.Args) != 2 {
		log.Fatal("usage: csvtrim input.csv")
	}
	f, err := os.Open(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()
	rows, err := csv.NewReader(f).ReadAll()
	if err != nil {
		log.Fatal(err)
	}
	if err := csv.NewWriter(os.Stdout).WriteAll(trim.Rows(rows)); err != nil {
		log.Fatal(err)
	}
}
GO
