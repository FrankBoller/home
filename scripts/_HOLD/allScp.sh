#!/bin/bash
id='$Id: hl2.sh,v 1.15 2007/07/09 16:34:05 fboller Exp $'
cat <<EOF

#############################################################################
# ${id}
# 
#############################################################################

EOF

if [ -f ~/.aliases ] ; then
    shopt -s expand_aliases
    source ~/.aliases
fi

bn=$(basename $0 .sh)
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

typeset -i E_OPTERR=0

options="hl:"
while getopts $options Option
do
  case $Option in
    h) E_OPTERR=65; break;;
    l) logFile=$OPTARG;;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
    h displays (this) Usage
    
    $(printf "%11.11s = %-6s\n" logFile    $logFile     )
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

for arg in $(set|fgrep scp|sed 's/=.*//'|grep -v '_\|arg'); do
 targetServer=$(eval echo ${d}$arg)
 scp $* ${targetServer}:.
done
