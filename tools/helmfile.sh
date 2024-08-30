#!/bin/bash

syncapp() {
  local helmfile_app="$@"
  local should_destroy=false

  if [[ "$helmfile_app" = *"-d"* || "$helmfile_app" = *"--destroy"* ]]; then
    app="$(echo "$app" | trim-args -d)"
    should_destroy=true
  fi

  if [[ -z "$helmfile_app" ]]; then
    echo "[syncapp] No app provided"
    return 1
  fi

  helmfile_app="$(echo "$helmfile_app" | xargs -I% -n1 echo -lapp=% | xargs)"

  if [[ "$should_destroy" = true ]]; then
    local destroy_cmd="helmfile destroy $helmfile_app --skip-deps --debug"

    echo -e "\e[35m[RUNNING] $destroy_cmd\e[0m"
    eval "$destroy_cmd"
  fi

  local sync_cmd="helmfile sync $helmfile_app --skip-deps --debug"

  echo -e "\e[35m[RUNNING] $sync_cmd\e[0m"
  eval "$sync_cmd"
}
