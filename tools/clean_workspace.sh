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
  local -a targets
  local answer
  echo "Scanning workspace under: $(pwd)"
  echo

  mapfile -d '' -t targets < <(sudo find . \
    -type d -name .git -prune -o \
    -type d \( -name node_modules -o -name .next -o -name .expo -o -name dist \
    -o -path '*/.bun/install/cache' \) \
    -prune \
    -print0)
  wait "$!" || return $?

  if [ "${#targets[@]}" -eq 0 ]; then
    echo "Nothing to remove."
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
