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
  echo "Scanning workspace under: $(pwd)"
  echo

  targets=$(find . \
    -type d \( -name node_modules -o -name .next \) \
    -prune \
    -print)

  if [ -z "$targets" ]; then
    echo "Nothing to remove."
    return 0
  fi

  echo "This will remove all the following directories:"
  echo "$targets"
  echo
  printf "Proceed with deletion? [y/N] "
  read answer

  case "$answer" in
    y|Y)
      echo
      echo "Removing..."
      printf "%s\n" "$targets" | xargs rm -rf
      ;;
    *)
      echo
      echo "Aborted."
      ;;
  esac
}
