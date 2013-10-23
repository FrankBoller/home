#!/bin/bash
# $Source: e:\local\cvsHome/home/fboller/scripts/chdir.sh,v $
id='$Id: chdir.sh,v 1.1 2007/08/01 23:16:40 fboller Exp $'
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

# bn=$(basename $0 .sh)
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

cdDir="$(cygpath -u $(cygpath -aml $1))"
cd "${cdDir}"

# rmdir $logDir > /dev/null 2>&1
