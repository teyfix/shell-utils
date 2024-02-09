tmpdump() {
  file_name=$(mktemp -t $1).$2
  mkdir -p $(dirname $file_name)
  cat >"$file_name" # This line reads from stdin and writes to the file
  code $file_name
}
