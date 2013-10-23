#!/bin/bash
# $Source: e:\local\cvsHome/home/fboller/scripts/sumThem.sh,v $
id='$Id: sumThem.sh,v 1.1 2007/08/01 23:16:40 fboller Exp $'
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
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

for arg in $*; do echo "### $arg"
  md5sum $arg | cut '-d ' -f1 | tee ${arg}.md5
  sha1sum $arg | cut '-d ' -f1 | tee ${arg}.sha1
done
# rmdir $logDir > /dev/null 2>&1
