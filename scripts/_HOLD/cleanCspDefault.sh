#!/bin/bash
id='$Id: cleanCspDefault.sh,v 1.11 2006/10/02 14:26:51 fboller Exp $'
cat <<EOF

#############################################################################
# ${id}
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

cspDefault=${JBOSS_HOME}/server/csp-default

aDirs=( log temp tmp translog data/temp data/translog )

set -x
if [ -d "$cspDefault" ] ; then
#  ${JBOSS_HOME}/bin/shutdown.bat -s localhost
#  sleep 15

  cd ${cspDefault}

  for arg in "${aDirs[@]}"; do
      rm -rf $arg
      mkdir -p $arg
  done
fi
set +x
# rmdir $logDir > /dev/null 2>&1
