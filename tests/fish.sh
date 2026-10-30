#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
test_dir=$(mktemp -d)
trap 'rm -rf -- "$test_dir"' EXIT
export HOME="$test_dir/home"
export XDG_CONFIG_HOME="$test_dir/config with spaces"
mkdir -p "$HOME/shell-utils" "$test_dir/bin"
cp -R "$repo_dir/tools" "$repo_dir/bootstrap.sh" "$repo_dir/bootstrap.fish" "$HOME/shell-utils/"

cat > "$HOME/shell-utils/tools/test.sh" <<'BASH'
test-args() { printf '%s\0' "$@"; }
test-stdin() { cat; }
test-status() { return 42; }
test-cd() { cd -- "$1"; }
BASH

# Exercise registration without updating or cloning a real checkout.
printf '#!/bin/sh\nexit 0\n' > "$test_dir/bin/git"
chmod +x "$test_dir/bin/git"
export PATH="$test_dir/bin:$PATH"
SHELL=/usr/bin/fish bash "$repo_dir/install.sh"
SHELL=/usr/bin/fish bash "$repo_dir/install.sh"
test "$(wc -l < "$XDG_CONFIG_HOME/fish/conf.d/shell-utils.fish")" -eq 1

cat > "$test_dir/check.fish" <<'FISH'
    functions -q clone commit wanip wanip4 wanip6; or exit 1
    set -l args (test-args "a b" "" "quote\"" '$literal' | string split0)
    test (count $args) -eq 4; or exit 1
    test "$args[1]" = "a b"; or exit 1
    test "$args[2]" = ""; or exit 1
    test "$args[3]" = "quote\""; or exit 1
    test "$args[4]" = '$literal'; or exit 1
    test (printf stdin | test-stdin) = stdin; or exit 1
    test-status
    test $status -eq 42; or exit 1
    test-cd "$XDG_CONFIG_HOME"; or exit 1
    test "$PWD" = "$XDG_CONFIG_HOME"; or exit 1
FISH
fish "$test_dir/check.fish"

touch "$HOME/.bashrc"
SHELL=/bin/bash bash "$repo_dir/install.sh"
grep -Fxq "source \"$HOME/shell-utils/bootstrap.sh\"" "$HOME/.bashrc"
echo 'Fish registration and tool bridge passed.'
