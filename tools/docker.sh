docker-name() {
  docker ps | grep "$1" | head -n 1 | awk '{print $1}'
}

docker-exec() {
  container_name=$(docker-name $1)
  shift
  docker exec -it $container_name "$@"
}

docker-attach() {
  docker-exec $1 /bin/sh
}
