show-node() {
  ps aux | grep "$HOME" | grep -E "node.*(dist|src)" | grep -vE '.vscode|grep'
}

kill-node() {
  local processes="$(show-node | awk '{print $2}')"
  local user_processes="$(show-node | awk '{print $1,$2}')"

  if [ -z "$processes" ]; then
    echo "No process found"
    return
  fi

  local count="$(echo "$processes" | wc -l)"
  local need_sudo=false

  while IFS= read -r line; do
    local user=$(echo $line | awk '{print $1}')
    local pid=$(echo $line | awk '{print $2}')
    if [ "$user" != "$(whoami)" ]; then
      need_sudo=true
      break
    fi
  done <<<"$user_processes"

  echo "Killing $count process(es): $(echo -n "$processes" | tr '\n' ',' | sed 's#,#, #')"

  if $need_sudo; then
    echo "$processes" | xargs -r sudo kill -9
  else
    echo "$processes" | xargs -r kill -9
  fi
}
