#!/bin/bash
# $Source: e:\local\cvsHome/home/fboller/scripts/parsoap.sh,v $
id='$Id: parsoap.sh,v 1.1 2007/01/28 22:37:42 fboller Exp $'
# cat <<EOF
# 
# #############################################################################
# # ${id}
# # 
# #############################################################################
# 
# EOF

if [ -f ~/.aliases ] ; then
    shopt -s expand_aliases
    source ~/.aliases
fi

bn=$(basename $0 .sh)
logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
mkdir -p $logDir
sedFile=${logDir}/soapLog.sed
rawFile=${logDir}/soapRaw.txt
cookedFile=${logDir}/cooked.xml

# logFile="${logDir}/logFile.log"
#################################

cat > ${sedFile} <<EOF
s/^/#/
s/[&]lt;/</g
s/[&]gt;/>/g
s/[&]quot;/"/g
s/.soapenv:/\n&/
s/</\n&/g
s/>/&\n/g
EOF
# s/^#.*//

tr -d '\n' < l4j.log | tr '\r' '\n' > ${rawFile}
sed -f ${sedFile} ${rawFile} | sed -e '/^#/d' > ${cookedFile}
( cd ${logDir}; g cooked.xml )
ls -lad ${cookedFile}

# rmdir $logDir > /dev/null 2>&1
