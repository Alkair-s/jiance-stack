#!/usr/bin/env bash
# Builds a tiny existing project in the eval workspace (the current directory):
# a README and a backup script that copies a folder into a timestamped archive.
set -eu

cat > README.md <<'EOF'
# nightly-backup

Copies a folder into a timestamped zip archive. Run: python backup.py SOURCE DEST
EOF

cat > backup.py <<'EOF'
import argparse
import shutil
import time


def main():
    parser = argparse.ArgumentParser(description="Back up a folder to a zip archive.")
    parser.add_argument("source")
    parser.add_argument("dest")
    args = parser.parse_args()
    stamp = time.strftime("%Y%m%d-%H%M%S")
    archive = shutil.make_archive(f"{args.dest}/backup-{stamp}", "zip", args.source)
    print(f"wrote {archive}")


if __name__ == "__main__":
    main()
EOF
