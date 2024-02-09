# Reduces repeating newlines to one from the input
trim-nf() {
  perl -00pe 's/\n\s*\n+/\n\n/g'
}

# filters the input to only show the lines that contain the keyword
#  and the lines after until a line starts with a whitespace or a digit
trim-logs() {
  awk -v keyword="$1" '$0 ~ keyword {print; flag=1; next} /^[0-9]|^--/ {if (flag) {flag=0; next}} flag {print}'
}
