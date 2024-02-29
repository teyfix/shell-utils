commit() {
  git commit -m "$@" --no-verify
}

soft-reset() {
  git reset --soft HEAD~1
}

hard-reset() {
  git reset --hard HEAD~1
}

commit-all() {
  git add .
  commit "$@"
}

push() {
  git push
}

push-all() {
  commit-all "$@"
  git push
}

trello() {
  dirname=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
  node "$dirname/trello/checkout.js" "$@"
}
