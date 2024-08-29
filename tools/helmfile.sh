#!/bin/bash

syncapp() {
  local app="$@"

  if [[ "$app" = *"-d"* || "$app" = *"--destroy"* ]]; then
    app="$(echo "$app" | tr -s '[:space:]' '\n' | grep -v '\-d' | xargs -n1 -I% echo -lapp=% | xargs)"
    echo "$app" | xargs -I% helmfile destroy % --skip-deps --debug
  fi

  echo "$app" | xargs -I% helmfile sync % --skip-deps --debug
}
