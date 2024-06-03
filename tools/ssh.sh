#!/bin/bash

ssh-iproute() {
  local traffic="$(ss -n sport 22 | tail -n+2 | grep -Po '\d+(\.\d+)+' | awk 'NR%2==0')"

  for ip in $traffic; do
    local ip_addr_after_via="$(ip route get "$ip" sport 22 | grep -Po '(?<=via )\d+(\.\d+)+((?! src).)+')"
    local new_ip_rule="$ip via $ip_addr_after_via"
    local old_ip_rule="$(ip route list | grep "$new_ip_rule")"

    if [ -z "$old_ip_rule" ]; then
      cat <<EOF
Adding missing rule: $new_ip_rule
EOF

      bash -c "sudo ip route add $new_ip_rule"
    else
      cat <<EOF
Skipping existing rule: $old_ip_rule
EOF
    fi
  done
}

ssh-public() {
  local temp_file="$(mktemp)"

  find ~/.ssh/ -name '*.pub' | xargs cat | sort | uniq | tee "$temp_file"
  code "$temp_file"
}
