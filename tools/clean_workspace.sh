# remove common build and dependency directories recursively
# starting from the current directory
#
# example:
# clean-workspace
#
# this will remove all the following directories:
# - node_modules
# - .next
clean-workspace() {
  local -a targets privileged_targets
  local answer
  echo "Scanning workspace under: $(pwd)"
  echo

  local -a scan=(find . \
    -type d \( -name .state -o -name .cache -o -name .git \) -prune -o \
    -type d \( -name node_modules -o -name .next -o -name .expo -o -name dist \) \
    -prune \
    -print0)
  mapfile -d '' -t targets < <("${scan[@]}")
  wait "$!" || {
    local scan_status=$?
    if [ "$scan_status" -gt 128 ]; then
      return "$scan_status"
    fi
    echo "Scan incomplete; retrying with sudo to include inaccessible directories." >&2
    mapfile -d '' -t privileged_targets < <(sudo "${scan[@]}")
    if wait "$!"; then
      targets=("${privileged_targets[@]}")
    else
      scan_status=$?
      if [ "$scan_status" -gt 128 ]; then
        return "$scan_status"
      fi
      echo "Warning: scan incomplete; continuing with accessible matches." >&2
    fi
  }

  if [ "${#targets[@]}" -eq 0 ]; then
    echo "No accessible matches to remove."
    return 0
  fi

  echo "This will remove all the following directories:"
  printf '%q\n' "${targets[@]}"
  echo
  printf "Proceed with deletion? [y/N] "
  read -r answer || return 1

  case "$answer" in
    y|Y)
      echo
      echo "Removing..."
      printf '%s\0' "${targets[@]}" | sudo xargs -0 -r rm -rf --one-file-system --
      ;;
    *)
      echo
      echo "Aborted."
      ;;
  esac
}
