#!/bin/bash
E_OPTERR=65
set +vx

num=10
fileName=

set -- `getopt "n:f:" "$@"`
# Sets positional parameters to command-line arguments.

while [ ! -z "$1" ]
do
  case "$1" in
    -n) num=$(echo $2 2*f | dc) ; shift;;
    -f) fileName=$2; shift;;
     *) break;;
  esac

  shift
done

if [ ! -f "$fileName" ]
then
  echo "Usage $0 -[options n:f:]"
  echo "n is for number of random lines"
  echo "f is the filename to randomly select lines"
  exit $E_OPTERR
fi  

maxLines=$(wc -l $fileName | cut "-d " -f1 )
# echo "maxLines = $maxLines"

for arg in $(openssl rand $num | od -t u2 | cut -c9- | xargs -n1 echo)
do
  # 2 17^ 1-f
  x=$(echo "$arg $maxLines * 131071/f" | dc);
  # printf "%10s ", $x
  tail +$x $fileName | head -1;
done
set +vx
