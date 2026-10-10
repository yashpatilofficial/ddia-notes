#!/usr/bin/env bash
set -euo pipefail

if ! command -v mdbook >/dev/null 2>&1; then
  echo "mdBook is required to build the Pages site." >&2
  exit 1
fi

rm -rf _site
mdbook build --dest-dir _site