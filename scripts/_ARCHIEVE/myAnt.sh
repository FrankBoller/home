#!/bin/bash
id='$Id: myAnt.sh,v 1.4 2006/04/22 19:11:00 fboller Exp $'
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

projectName="all"
typeset -i E_OPTERR=0
typeset -i fTail=1
typeset -i fVerbose=0

options="hl:p:tv"
while getopts $options Option
do
  case $Option in
    h) E_OPTERR=65; break;;
    l) logFile=$OPTARG;;
    p) projectName=$OPTARG;;
    t) (( fTail = ! fTail ));;
    v) (( fVerbose = ! fVerbose ));;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

shift $(($OPTIND - 1))
# Move argument pointer to next.

(( $fVerbose != 0 )) && verbose="-v";

if [ $E_OPTERR != 0 ]
then
  echo "Usage $0 -[$options]"
  echo "  h displays (this) Usage"
  echo "  l is the name of the logfile: $logFile"
  echo "  p is project name: $projectName"
  echo "  t toggle fTail: $fTail"
  echo "  v toggle fVerbose: $fVerbose $verbose"
  exit $E_OPTERR
fi

set -vx
time ant $verbose $projectName > $logFile 2>&1 &
set +vx

# ( wait; printf "\n\n\n\n\n/////////////////// END BG\n\n\n" >> $logFile )

(( fTail != 0 )) && ( cat $logFile; tail -f $logFile; ) || echo "cat $logFile; tail -f $logFile"

rmdir $logDir > /dev/null 2>&1
