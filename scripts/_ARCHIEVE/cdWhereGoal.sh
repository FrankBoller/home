#!/bin/bash
id='$Id: cdWhereGoal.sh,v 1.7 2006/04/22 19:10:58 fboller Exp $'
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

here=$(pwd)

typeset -i E_OPTERR=0

options="h"
while getopts $options Option
do
  case $Option in
    h) E_OPTERR=65; break;;
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
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

function bailOut() { 
  cat <<EOF

#############################################################################
# FATAL ERROR
#############################################################################

$1

EOF

  exit -1
}

function getVar() { p1=$d{; p2=}; eval echo $p1$1[$2]$p2; }

function cdWhereGoal() { 
  printf "%24.24s. %24.24s %-24.24s\n" cdWhereGoal "cd $1;" "$2"
  cd ${here}/"$1"

  logFile="${logDir}/log.$(echo "$1 $2" | tr -cs '[^[:alnum:].]' '_').log"

  cat > ${logFile} 2>&1 <<EOF










#############################################################################
#  $2
#############################################################################

EOF

  eval "$2" >> ${logFile} 2>&1
  status=$(fgrep BUILD ${logFile} | tail -1)

  if [ "$status" != "BUILD SUCCESSFUL" ] ; then
    cat ${logFile}
    bailOut "$status $(basename ${logFile})"
  fi

  echo $status
  echo ""
}

#############################################################################

aCoreJarInstall=(         core                 'maven jar:install' )
aTypesJarInstall=(        websvc-types         'maven jar:install' )
aComponentsJarClean=(     dependent-components 'maven clean' )
aComponentsJarEar=(       dependent-components 'maven ear' )
aComponentsJarEarDeploy=( dependent-components 'maven ear:appserver.deploy' )

aWhereGoal=(
  aCoreJarInstall
  aTypesJarInstall
  aComponentsJarClean
  aComponentsJarEar
  aComponentsJarEarDeploy
)

for whereGoal in ${aWhereGoal[@]}; do
  where="$(getVar $whereGoal 0)"
  goal="$(getVar $whereGoal 1)"
  cdWhereGoal "$where" "$goal"
done

set +vx

rmdir $logDir > /dev/null 2>&1
