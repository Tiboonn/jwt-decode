#!/bin/sh

base64Decoded=""

decode_base64_url() {
  local len=$((${#1} % 4))
  local result="$1"
  if [ $len -eq 2 ]; then result="$1"'=='
  elif [ $len -eq 3 ]; then result="$1"'='
  fi
  base64Decoded=$(echo "$result" | tr '_-' '/+' | openssl enc -d -A -base64)
}

decode_jwt() {
  decode_base64_url $(echo -n $2 | cut -d "." -f $1)
}

  
decode_jwt $1 $2
if echo $base64Decoded | jq empty; then
  echo $base64Decoded | jq -r . | jq .
else
  echo "JSON is invalid"
fi

