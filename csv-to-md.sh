#!/bin/bash

CSVFILE="$1"
OUT="$2"

function print_help {
  echo "$0 <in: csv file> <optinal: out: md file>" 
}

if [[ -z $CSVFILE ]]; then
  print_help
  exit 1
fi

if [[ -z $OUT ]]; then
  OUT="$(cut -d"." -f1 <<< "$CSVFILE")_converted.md"
fi

WITHPIPE="$(sed 's/^/|/' $CSVFILE)"
MDCONTENT="$(sed -e 's/;/|/g' <<< "$WITHPIPE")"
HEADCHAR="$(head -n1 <<< "$MDCONTENT" |  awk '{ print length; }')"

for i in $(seq 3 ${HEADCHAR}); do
  HEADER="${HEADER}$(echo -n "|--")"
done
HEADER="${HEADER}$(echo -n "|")"

echo "$(head -n1 <<< "$MDCONTENT")" >> $OUT
echo "$HEADER" >> $OUT
echo "$MDCONTENT" >> $OUT