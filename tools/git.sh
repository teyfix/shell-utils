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

safe-push() {
  local git_origin="$(git remote)"
  local git_branch="$(git branch --show-current)"

  # Check if the remote branch exists
  if git ls-remote --heads "$git_origin" "$git_branch" | grep -q "$git_branch"; then
    echo "Remote branch exists. Pushing changes..."
    git push "$git_origin" "$git_branch"
  else
    echo "Remote branch does not exist. Pushing and setting upstream..."
    git push -u "$git_origin" "$git_branch"
  fi
}

push() {
  safe-push
}

push-all() {
  commit-all "$@"
  safe-push
}

trello() {
  dirname=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
  node "$dirname/trello/checkout.js" "$@"
}

chdev() {
  git checkout dev
  git pull -p
}
