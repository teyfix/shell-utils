# Reduces repeating newlines to one from the input
trim-nf() {
  awk 'NF > 0 {print; p=1} NF == 0 && p {print; p=0}'
}

# filters the input to only show the lines that contain the keyword
#  and the lines after until a line starts with a whitespace or a digit
trim-logs() {
  awk -v keyword="$1" '$0 ~ keyword {print; flag=1; next} /^[0-9]|^--/ {if (flag) {flag=0; next}} flag {print}'
}
