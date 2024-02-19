#!/bin/bash

bash <<'EOF'
tools_dir=$(dirname $0)/tools

for file in $tools_dir/*.sh; do
  source "$file"
done
EOF
