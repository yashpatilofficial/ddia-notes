#!/usr/bin/env bash
set -euo pipefail

if ! command -v pandoc >/dev/null 2>&1; then
  echo "Pandoc is required to build the Pages site." >&2
  exit 1
fi

output_dir="_site"
rm -rf "$output_dir"
mkdir -p "$output_dir"

has_root_index=false
if [[ -f index.md ]]; then
  has_root_index=true
fi

while IFS= read -r -d '' source; do
  relative_path="${source#./}"
  title="${relative_path##*/}"
  title="${title%.md}"

  if [[ "$relative_path" == "README.md" && "$has_root_index" == false ]]; then
    destination="$output_dir/index.html"
  elif [[ "$relative_path" == "index.md" ]]; then
    destination="$output_dir/index.html"
  elif [[ "$relative_path" == "README.md" ]]; then
    destination="$output_dir/README.html"
  else
    destination="$output_dir/${relative_path%.md}.html"
  fi

  mkdir -p "$(dirname "$destination")"
  pandoc "$source" --standalone --metadata "title=$title" --output "$destination"
done < <(find . -type f -name '*.md' -not -path './.git/*' -not -path "./$output_dir/*" -print0)