#!/bin/bash
# $Source: e:\local\cvsHome/home/fboller/scripts/hl.sh,v $
id='$Id: hl.sh,v 1.14 2006/11/08 18:47:01 fboller Exp $'
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
logFile="${logDir}/logFile.log"
#################################

set -x

fgrep DeteAppFuseReverseEngineeringDelegator $TEMP/l4j.log \
  | sed \
    -e 's/.*reveng.DeteAppFuseReverseEngineeringDelegator.//' \
    -e '/exclude.*override:/d' \
    -e '/getForeignKeys/d' \
    -e "s/,/,\n....../g" \
  > ${logFile}

set +x

(cd ${logDir};g $(cygpath -ams ${logFile} ) )

# rmdir $logDir > /dev/null 2>&1
