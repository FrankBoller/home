#!/bin/bash
id='$Id: clean80.sh,v 1.2 2006/05/04 17:10:54 fboller Exp $'
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
logDir="/tmp/logDir/${bn}/$(now.sh)"
mkdir -p $logDir
logFile="${logDir}/logFile.log"
#################################


cd ${JBOSS_HOME}/server
dir1=csp-80
dir2=$$

mkdir ${dir2}
mv ${dir1}/{conf,deploy,lib} ${dir2}
rm -rf ${dir1}
mv ${dir2} ${dir1}

rmdir $logDir > /dev/null 2>&1
