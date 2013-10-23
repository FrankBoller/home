#!/bin/bash
id='$Id: soaTest.sh,v 1.7 2006/04/22 19:11:01 fboller Exp $'
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
logDir="/tmp/logDir/${bn}/$(now.sh)"
mkdir -p $logDir
logFile="${logDir}/logFile.log"
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
    l is the name of the logfile    : $logFile
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

echo "st.exe -cmd -runtest $*"
st.exe -cmd -runtest $*
rmdir $logDir > /dev/null 2>&1
