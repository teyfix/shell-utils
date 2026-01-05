zip-size() {
  zip -q - "$1" | wc -c | numfmt --to=iec
}