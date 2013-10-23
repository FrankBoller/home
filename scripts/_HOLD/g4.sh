#!/bin/bash
id='$Id: g4.sh,v 1.1 2007/08/01 23:16:40 fboller Exp $'
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

testName="-Dtest=DlmeMechanismsDaoTest"
testName=

bn=$(basename $0 .sh)
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

typeset -i E_OPTERR=0

options="ahl:t:"
while getopts $options Option
do
  case $Option in
    a) testName="";;
    h) E_OPTERR=65; break;;
    l) logFile=$OPTARG;;
    t) testName="-Dtest=$OPTARG";;
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
    
    l) $(printf "%11.11s = %-6s \n" logFile    $logFile     )
    t) $(printf "%11.11s = %-6s \n" testName   $testName    )
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

cd ${TEMP}
ls -ladt l4j.log
if [ -f l4j.log ] ; then
  g l4j.log
fi
