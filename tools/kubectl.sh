# get the first pod name that matches the given name
#
# kube-name mongo
kube-name() {
  kubectl get pods | grep "$1" | head -n 1 | awk '{print $1}'
}

# execute a command in the first pod that matches the given name
#
# example:
# kube-exec prosody uname -a
kube-exec() {
  pod_name=$(kube-name $1)
  shift
  kubectl exec $pod_name -it -- "$@"
}

# attach to the first pod that matches the given name
kube-attach() {
  pod_name=$(kube-name $1)
  kubectl exec $pod_name -it -- /bin/sh
}

# get the logs of the first pod that matches the given name
#
# if a keyword is provided, only the line that contain
# the keyword and the lines after until a line starts
# with a whitespace or a digit
kube-logs() {
  pod_name=$(kube-name $1)
  shift
  keyword="$@"

  # Use the provided pod_name for selecting the pod and keyword for filtering logs
  kubectl logs $pod_name -f --tail 0 | trim-logs $keyword
}

kube-logs-all() {
  pod_name=$(kube-name $1)
  shift
  keyword="$@"

  kubectl logs $pod_name -f | trim-logs $keyword
}

kube-follow() {
  kubectl logs $(kube-name $1) -f --tail 0
}

# delete the first pod that matches the given name
kube-del() {
  kubectl delete pod $(kube-name $1) | tail -f | grep "deleted" | head -1
}

kube-svc() {
  local filter="$1"

  list_svc() {
    kubectl get services -A | awk '{printf "http://%s.%s.svc.cluster.local\n", $2, $1}'
  }

  if [ -z "$filter" ]; then
    list_svc
  else
    list_svc | grep "$filter"
  fi
}
