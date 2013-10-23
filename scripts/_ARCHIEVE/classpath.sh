#!/bin/bash
# $Id: classpath.sh,v 1.2 2005/12/14 17:00:58 fboller Exp $
#############################################################################

E_OPTERR=65
IFS=" \\t\\n"
action=
bn=$(basename $0)

# -a add
# -j JAVACLASSPATH
# -r reset
# -s set
# -v view

# echo "@ $@"

options=a:jrs:v
set -- `getopt $options "$@"`
# Sets positional parameters to command-line arguments.

while [ ! -z "$1" ]
do
  echo "$1 $2"
  action=$1
  case "$1" in
    -a) export CLASSPATH="${CLASSPATH};$2" ; shift;;
    -j) export CLASSPATH="${JAVACLASSPATH}"; shift;;
    -s) export CLASSPATH=".;$2" ; shift;;
    -r) export CLASSPATH=. ; shift;;
    -v) IFS=";"
        cat <<EOF

#############################################################################
# JAVACLASSPATH
#############################################################################
  $(for arg in ${JAVACLASSPATH[@]} ; do echo "$arg"; done)

#############################################################################
# CLASSPATH
#############################################################################
  $(for arg in ${CLASSPATH[@]} ; do echo "$arg"; done)

#############################################################################

EOF
      IFS=" \\t\\n"
      shift;;
     *) break;;
  esac

  shift
done

if [ "$action" = "" ]
then
  echo "Usage $0 -[options $options]"
  echo "a == add (CLASSPATH=${CLASSPATH};${d}2))"
  echo "j == javaclasspath (CLASSPATH=${d}JAVACLASSPATH)"
  echo "r == reset (CLASSPATH=.)"
  echo "s == set (CLASSPATH=${d}2)"
  echo "v == view"
# echo "SHLVL $SHLVL"
  (( $SHLVL > 1 )) && exit $E_OPTERR || return $E_OPTERR
fi  

echo "$CLASSPATH"

#############################################################################
# 
# maxLines=$(wc -l $fileName | cut "-d " -f1 )
# # echo "maxLines = $maxLines"
# 
# for arg in $(openssl rand $num | od -t u2 | cut -c9- | xargs -n1 echo)
# do
#   # 2 17^ 1-f
#   x=$(echo "$arg $maxLines * 131071/f" | dc);
#   # printf "%10s ", $x
#   tail +$x $fileName | head -1;
# done
# set +vx
#    -a) export CLASSPATH="${CLASSPATH};$2" ; shift;;
#    -j) export CLASSPATH="${JAVACLASSPATH}"; shift;;
#    -s) export CLASSPATH=".;$2" ; shift;;
#    -r) export CLASSPATH=. ; shift;;
