commit() {
  git commit -m "$@" --no-verify
}

soft-reset() {
  git reset --soft HEAD~1
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
