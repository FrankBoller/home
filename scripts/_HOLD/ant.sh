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

# ws_home="C:/local/IBM/WebSphere/AppServer"
# ant_home=${ws_home}/deploytool/itp/plugins/org.apache.ant_1.6.5
# java_home=${ws_home}/java
# PATH=${java_home}/bin:%PATH%
# PATH=${ant_home}/bin;%PATH%
# 
# ${ant_home}/bin/ant *
/c/local/scripts/antws.bat *
