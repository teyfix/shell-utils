#!/bin/bash
bunfig() {
  local pwd="$(pwd)"
  local dir="$pwd"

  while [ "$dir" != "/" ]; do
    local file=$(find "$dir" -name 'bunfig.toml' -not -path '*/node_modules/*' -not -path '*/.*/*' -print -quit)

    if [ -n "$file" ]; then
      local relative="$(realpath --relative-to="$pwd" "$file")"

      cat "$file" | tee bunfig.toml >/dev/null
      echo "Copied bunfig.toml from: $relative"
      return 0
    fi

    dir="$(dirname "$dir")"
  done

  echo "No bunfig.toml file found!"
  return 1
}
