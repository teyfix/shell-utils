commit() {
  local message="$@"
  shift $#
  git commit -m "$message" --no-verify
}

safe-commit() {
  local message="$@"
  shift $#
  git commit -m "$message" 
}

soft-reset() {
  git reset --soft HEAD~1
}

hard-reset() {
  git reset --hard HEAD~1
}

commit-all() {
  local message="$@"
  shift $#
  git add .
  commit "$message"
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
  git pull --rebase
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

ch2() {
  git checkout "$1"
  pull
}

chdev() {
  ch2 dev
}

chmain() {
  ch2 main
}

chmaster() {
  ch2 master
}

clone() {
  set -euo pipefail

  if [[ $# -ne 1 ]]; then
    echo "Usage: clone <author/repo | github url>"
    return 1
  fi

  local input="$1"
  local path author repo target

  case "$input" in
    git@github.com:*)
      path="${input#git@github.com:}"
      ;;
    https://github.com/*)
      path="${input#https://github.com/}"
      ;;
    *)
      path="$input"
      ;;
  esac

  path="${path%.git}"

  author="${path%%/*}"
  repo="${path##*/}"

  if [[ -z "$author" || -z "$repo" ]]; then
    echo "Invalid repository format"
    return 1
  fi

  target="$HOME/git/$author/$repo"

  mkdir -p "$(dirname "$target")"

  if [[ -d "$target/.git" ]]; then
    echo "Repository already exists at $target"
    return 0
  fi

  git clone "https://github.com/$author/$repo.git" "$target"
  cd "$target"
}
