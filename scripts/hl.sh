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
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

echo "....|....1....|....2....|....3....|....4....|....5....|....6....|....7....|....8....|....9....|....0....!....1....!....2....!....3....!....4....!....5....!....6....!....7....!...."
# rmdir $logDir > /dev/null 2>&1
