#!/bin/bash
npmrc() {
  depth-first-copy .npmrc

  if [ -f ".gitignore" ]; then
    add-uniq-line ".gitignore" ".npmrc"
  fi
}
