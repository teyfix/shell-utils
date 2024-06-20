show-node() {
  ps aux | grep "$HOME" | grep -E "node.*(dist|src)" | grep -vE '.vscode|grep'
}

kill-node() {
  local processes="$(show-node | awk '{print $2}')"

  if [ -z "$processes" ]; then
    echo "No process found"
    return
  fi

  local count="$(echo "$processes" | wc -l)"

  echo "Killing $count process(es): $processes"
  echo "$processes" | xargs -r sudo kill -9
}
