show-node() {
  ps aux | grep -P "node.*dist|node.*src" | grep -v '.vscode' | head -n -1
}

kill-node() {
  local processes

  read -r processes <<<"$(show-node | awk '{print $2}')"

  if [ -z "$processes" ]; then
    echo "No process found"
    return
  fi

  local count

  read -r count <<<"$(echo "$processes" | wc -l)"

  echo "Killing $count process(es): $processes"
  echo "$processes" | xargs -r sudo kill -9
}
