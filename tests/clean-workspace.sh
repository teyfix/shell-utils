#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../tools/clean_workspace.sh"
test_dir=$(mktemp -d)
trap '/bin/rm -rf -- "$test_dir"' EXIT
cd "$test_dir"

# Never invoke real sudo in the tests.
mkdir bin
cat > bin/sudo <<'BASH'
#!/usr/bin/env bash
printf '%s\n' "$1" >> "$SUDO_TEST_LOG"
if [ "${SUDO_TEST_FAIL:-0}" = 1 ]; then exit 1; fi
export CLEAN_WORKSPACE_TEST_ELEVATED=1
"$@"
BASH
chmod +x bin/sudo
export PATH="$test_dir/bin:$PATH"
export SUDO_TEST_LOG="$test_dir/sudo.log"

mkdir -p 'project with spaces/node_modules' $'project\nnewline/dist' \
  project/.next project/.expo project/.state/node_modules project/.git/dist \
  project/.cache/dist agent/home/.bun/install/cache/package/dist \
  agent/home/.bun/bin agent/home/.bun/install/global \
  project/.cache/bun/downloads/pkg/dist project/.cache/tool/bun/pkg/dist \
  project/.cache/tool/bun-cache/pkg/dist project/.cache/tool/bun-clean-cache/pkg/dist \
  project/tools/bun project/.cache/flutter/sdk/version/tools/dist \
  project/.cache/dart/pub/hosted/pkg/dist
touch 'project with spaces/keep'
touch project/.state/runtime-data project/.cache/keep
clean-workspace <<< n >preview
grep -Fxq './agent/home/.bun/install/cache' preview
for cache in project/.cache/bun project/.cache/tool/bun project/.cache/tool/bun-cache project/.cache/tool/bun-clean-cache; do
  grep -Fxq "./$cache" preview
done
if grep -Eq '/pkg/dist|/sdk/.*/dist' preview; then
  echo 'Package caches must be compacted and installed SDK files preserved' >&2
  exit 1
fi
if grep -Fq '/cache/package/dist' preview; then
  echo 'Bun cache must be listed once without nested targets' >&2
  exit 1
fi
test -d 'project with spaces/node_modules'
test -d agent/home/.bun/install/cache/package/dist
clean-workspace <<< y
test ! -e 'project with spaces/node_modules'
test ! -e $'project\nnewline/dist'
test ! -e project/.next
test ! -e project/.expo
test -e 'project with spaces/keep'
test ! -e project/.state/node_modules
test -d project/.git/dist
test ! -e project/.cache/dist
test -e project/.state/runtime-data
test -e project/.cache/keep
test ! -e agent/home/.bun/install/cache
test -d agent/home/.bun/bin
test -d agent/home/.bun/install/global
test ! -e project/.cache/bun
test ! -e project/.cache/tool/bun
test ! -e project/.cache/tool/bun-cache
test ! -e project/.cache/tool/bun-clean-cache
test -d project/tools/bun
test -d project/.cache/flutter/sdk/version/tools/dist
test -d project/.cache/dart/pub/hosted/pkg/dist
clean-workspace </dev/null
grep -qx xargs "$SUDO_TEST_LOG"

# Denied scan elevation must stop without deleting anything.
mkdir node_modules
export SUDO_TEST_FAIL=1
scan_status=0
clean-workspace <<< y || scan_status=$?
test "$scan_status" -ne 0
test -d node_modules
unset SUDO_TEST_FAIL

# A successful privileged scan must be included in the confirmation.
mkdir dist
find() {
  if [ "${CLEAN_WORKSPACE_TEST_ELEVATED:-0}" = 1 ]; then
    printf './node_modules\0./dist\0'
  else
    echo 'Unexpected unprivileged scan' >&2
    return 1
  fi
}
export -f find
clean-workspace <<< n >preview
grep -q './dist' preview
test -d node_modules
test -d dist
clean-workspace <<< y
test ! -e node_modules
test ! -e dist

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

# A failed privileged scan must not delete its partial results.
find() { printf './node_modules\0'; return 1; }
scan_status=0
clean-workspace <<< y || scan_status=$?
test "$scan_status" -eq 1
test -d node_modules

# Confirmed deletion uses sudo immediately, without an unprivileged attempt.
unset -f find
cat > bin/rm <<'BASH'
#!/usr/bin/env bash
if [ "${CLEAN_WORKSPACE_TEST_ELEVATED:-0}" != 1 ]; then
  echo 'Unexpected unprivileged deletion' >&2
  exit 1
fi
exec /bin/rm "$@"
BASH
chmod +x bin/rm
clean-workspace <<< y
test ! -e node_modules
test -e 'project with spaces/keep'
test -e project/.state/runtime-data
grep -qx xargs "$SUDO_TEST_LOG"

# Denied elevation must report failure and leave the target in place.
mkdir node_modules
export SUDO_TEST_FAIL=1
delete_status=0
clean-workspace <<< y || delete_status=$?
test "$delete_status" -ne 0
test -d node_modules
echo 'Workspace cleanup checks passed.'
