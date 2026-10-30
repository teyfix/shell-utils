#!/bin/bash
tools_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/tools"

for file in "$tools_dir"/*.sh; do
  source "$file"
done
