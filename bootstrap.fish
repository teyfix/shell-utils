#!/usr/bin/env fish
set -l shell_utils_root (path dirname (status filename))
set shell_utils_root (path resolve "$shell_utils_root")

for tool in (bash -c 'source "$1/bootstrap.sh"; declare -F' -- "$shell_utils_root" | string replace -r '^declare -f ' '')
    function $tool --inherit-variable shell_utils_root --inherit-variable tool
        set -l cwd_file (mktemp)
        or return 1
        # Bash runs the existing tools; pass its final directory back to fish.
        bash -c 'source "$1/bootstrap.sh"; cwd_file=$2; shift 2; "$@"; result=$?; printf "%s\0" "$PWD" > "$cwd_file"; exit "$result"' -- "$shell_utils_root" "$cwd_file" "$tool" $argv
        set -l result $status
        set -l target (string split0 < "$cwd_file")
        command rm -f -- "$cwd_file"
        if test (count $target) -eq 1; and test "$target" != "$PWD"
            cd -- "$target"
            or return 1
        end
        return $result
    end
end

source "$shell_utils_root/tools/ip.sh"
