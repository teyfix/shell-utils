#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../tools/clean_workspace.sh"
test_dir=$(mktemp -d)
trap 'rm -rf -- "$test_dir"' EXIT
cd "$test_dir"

mkdir -p 'project with spaces/node_modules' $'project\nnewline/dist' \
  project/.next project/.expo project/.state/node_modules project/.git/dist \
  project/.cache/dist
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
test -d project/.cache/dist
clean-workspace </dev/null

# Inaccessible directories must not block cleanup of accessible matches.
mkdir node_modules
find() { printf './node_modules\0'; return 1; }
clean-workspace <<< y 2>warning
test ! -d node_modules
grep -q 'scan incomplete' warning

# An interrupted scan must still stop cleanup.
mkdir node_modules
find() { printf './node_modules\0'; return 130; }
scan_status=0
clean-workspace <<< y || scan_status=$?
if [ "$scan_status" -ne 130 ]; then
  echo 'Expected an interrupted scan to stop cleanup' >&2
  exit 1
fi
test -d node_modules
echo 'Workspace cleanup checks passed.'
