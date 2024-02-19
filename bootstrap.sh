#!/bin/bash
tools_dir="$HOME/shell-utils/tools"

for file in $tools_dir/*.sh; do
  source "$file"
done
