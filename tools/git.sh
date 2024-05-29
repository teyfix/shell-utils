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
  local git_origin="$(git remote | head -n1)"
  local git_branch="$(git branch --show-current)"

  # Check if the remote branch exists
  if git ls-remote --heads "$git_origin" "$git_branch" | grep -qo "$git_branch"; then
    echo "Remote branch exists"
    pull

    local commits_ahead=$(git rev-list --count $git_origin/$git_branch..$git_branch)

    # Check if there are any commits ahead of the remote branch
    if [[ $commits_ahead -eq 0 ]]; then
      echo "Nothing to push"
    else
      echo "Pushing the changes..."
      git push "$git_origin" "$git_branch"
    fi
  else
    echo "Remote branch does not exist. Pushing and setting upstream..."
    git push -u "$git_origin" "$git_branch"
  fi
}

pull() {
  echo "Pulling the changes..."
  git pull --ff >/dev/null
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

chmain() {
  git checkout main
  git pull -p
}

chmaster() {
  git checkout master
  git pull -p
}
