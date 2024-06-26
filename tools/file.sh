#!/bin/bash
tmpdump() {
  file_name=$(mktemp -t $1_XXXXXX).$2
  mkdir -p $(dirname $file_name)
  cat >"$file_name" # This line reads from stdin and writes to the file
  code $file_name
}

depth-first-find() {
  local entry="$1"
  local pattern="$2"

  if [ -z "$pattern" ]; then
    pattern="$entry"
    entry="$(pwd)"
  fi

  if [ -z "$entry" ] || [ -z "$pattern" ]; then
    echo "Usage: depth-first-find [entry-point] file_pattern" >&2
    return 1
  fi

  local current_dir="$(realpath "$entry")"

  if [ ! -d "$current_dir" ]; then
    echo "Directory not found: $current_dir" >&2
    return 1
  fi

  while [[ "$current_dir" == "/home/"* ]]; do
    # Find the bunfig.toml file, excluding node_modules and hidden directories
    local found_file="$(find "$current_dir" -name "$pattern" -not -path '*/node_modules/*' -not -path '*/.*/*' -print -quit)"

    if [ -n "$found_file" ]; then
      echo "$found_file"
      return 0
    fi

    current_dir="$(dirname "$current_dir")"
  done

  echo "No file found with pattern: $pattern" >&2
  return 1
}

depth-first-copy() {
  local entry="$1"
  local pattern="$2"

  if [ -z "$pattern" ]; then
    pattern="$entry"
    entry="$(pwd)"
  fi

  if [ -z "$entry" ] || [ -z "$pattern" ]; then
    echo "Usage: depth-first-copy [entry-point] file_pattern" >&2
    return 1
  fi

  local found_file

  found_file="$(depth-first-find "$entry" "$pattern")"

  if [ $? -ne 0 ]; then
    return 1
  fi

  if [ -f "$pattern" ]; then
    echo "$pattern already exists in current directory" >&2
    return 1
  fi

  local current_dir="$(pwd)"

  if cp "$found_file" "$current_dir"; then
    echo "Copied $(basename "$found_file") from $(realpath "$found_file" --relative-to="$current_dir")"
  fi
}

add-uniq-line() {
  local file="$1"
  local line="$2"

  if grep -qx "$line" "$file"; then
    echo "$line is already in $file"
    return 0
  fi

  echo "$line" | tee -a "$file" >/dev/null
  echo "Added $line to $file"
}
