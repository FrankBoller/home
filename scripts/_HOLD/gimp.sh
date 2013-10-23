#!/bin/bash
id='$Id: gimp.sh,v 1.8 2006/10/02 14:26:51 fboller Exp $'
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
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################
export PATH=${PATH}:"${SYSTEMDRIVE}\Program Files\GIMP-2.0\bin:${SYSTEMDRIVE}\Program Files\Common Files\GTK\2.0\bin"
gimp-2.2.exe
# rmdir $logDir > /dev/null 2>&1
