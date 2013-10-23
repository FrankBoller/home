#!/bin/bash
id='$Id: backSlash.sh,v 1.4 2006/04/05 23:42:16 fboller Exp $'
cat <<EOF

#############################################################################
# ${id}
# 
#############################################################################

EOF

# if [ -f ~/.aliases ] ; then
#     shopt -s expand_aliases
#     source ~/.aliases
# fi
# 
# bn=$(basename $0 .sh)
# logDir="/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
# #################################

for arg in $*
do
    echo $arg | sed 's,^\./,,' | tr '/' '\\'
done
