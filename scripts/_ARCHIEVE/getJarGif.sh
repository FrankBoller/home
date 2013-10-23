#!/bin/bash
id='$Id: getJarGif.sh,v 1.7 2006/04/22 19:10:59 fboller Exp $'
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

if [ -f ~/.aliases ] ; then
    shopt -s expand_aliases
    source ~/.aliases
fi

for arg in *.jar
do
    jar tf $arg | fgrep -i .gif > ${logDir}/1.1
    jar xvf $arg $(cat ${logDir}/1.1)
done

echo "logDir: ${logDir}"
rmdir $logDir > /dev/null 2>&1
