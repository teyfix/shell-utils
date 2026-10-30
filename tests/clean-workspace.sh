#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../tools/clean_workspace.sh"
test_dir=$(mktemp -d)
trap 'rm -rf -- "$test_dir"' EXIT
cd "$test_dir"

mkdir -p 'project with spaces/node_modules' $'project\nnewline/dist' \
  project/.next project/.expo project/.state/node_modules project/.git/dist
touch 'project with spaces/keep'
clean-workspace <<< n
test -d 'project with spaces/node_modules'
clean-workspace <<< y
test ! -e 'project with spaces/node_modules'
test ! -e $'project\nnewline/dist'
test ! -e project/.next
test ! -e project/.expo
test -e 'project with spaces/keep'
test -d project/.state/node_modules
test -d project/.git/dist
clean-workspace </dev/null

# A failed scan must not proceed with a partial deletion list.
mkdir node_modules
find() { printf './node_modules\0'; return 1; }
if clean-workspace <<< y; then
  echo 'Expected a failed scan to stop cleanup' >&2
  exit 1
fi
test -d node_modules
echo 'Workspace cleanup checks passed.'
