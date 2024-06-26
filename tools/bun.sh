#!/bin/bash
bunfig() {
  depth-first-copy bunfig.toml

  if [ -f ".gitignore" ]; then
    add-uniq-line ".gitignore" "bunfig.toml"
  fi
}
