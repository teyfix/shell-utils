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

docker-logs() {
  container_name=$(docker-name $1)
  docker logs -f $container_name
}

mongo-host() {
  docker ps | grep mongo | awk '{print "127.0.0.1 "$1}' | sudo tee -a /etc/hosts
}
