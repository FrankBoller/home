#!/bin/bash
id='$Id: mvnccic.sh,v 1.2 2007/08/10 15:09:51 fboller Exp $'
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
logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
mkdir -p $logDir
logFile="${logDir}/logFile.log"
keep=clean
#################################

typeset -i E_OPTERR=0

options="hkl:"
while getopts $options Option
do
  case $Option in
    k) keep=;;
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
    h) displays (this) Usage
    k) keep=;;
    
    $(printf "%11.11s = %-6s\n" keep    $keep     )
    $(printf "%11.11s = %-6s\n" logFile  $logFile   )
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

set -x
mvn ${MVN_OPTIONS} $* clean compile install ${keep} | tee ${logFile} 2>&1
set +x

fgrep package ${logFile} | sed -e 's/ does not exist//' -e 's/.*package/package/' | sort -u

echo
echo ${logFile}

fgrep -q '[ERROR]' ${logFile} && exit -1 || exit 0

# rmdir $logDir > /dev/null 2>&1
