#!/usr/bin/env bash
# Prints the modules a change touches, as a JSON array of directories, for
# the CI matrix: modules=["export","tools/mesh2web"].
#
# A module is a directory with a go.mod. A changed file belongs to the
# deepest module directory above it. A change to something every module uses
# (lint config, the CI workflow, this script) selects every module, and so
# does a base commit that is missing or unknown (new branch, force push).
#
# Usage: changed-modules.sh <base-sha> <head-sha>
set -euo pipefail

base=${1:-}
head=${2:-HEAD}

mapfile -t modules < <(git ls-files -- '*/go.mod' | xargs -r -n1 dirname | sort -u)

emit() {
  printf 'modules=%s\n' "$(printf '%s\n' "$@" | sort | jq -Rnc '[inputs | select(length > 0)]')"
}

if [[ -z "$base" || "$base" =~ ^0+$ ]] || ! git cat-file -e "${base}^{commit}" 2>/dev/null; then
  emit "${modules[@]}"
  exit 0
fi

declare -A hit=()
while IFS= read -r file; do
  case "$file" in
    .golangci.yml | .github/workflows/ci.yml | .github/scripts/*)
      emit "${modules[@]}"
      exit 0
      ;;
  esac
  best=""
  for m in "${modules[@]}"; do
    if [[ "$file" == "$m/"* && ${#m} -gt ${#best} ]]; then
      best=$m
    fi
  done
  if [[ -n "$best" ]]; then
    hit[$best]=1
  fi
done < <(git diff --name-only "${base}...${head}")

emit "${!hit[@]}"
