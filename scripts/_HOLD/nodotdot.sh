#!/bin/bash
id='$Id: nodotdot.sh,v 1.9 2006/10/02 14:26:52 fboller Exp $'
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

bn=$(basename $0 .sh)
logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

dotsFound=$logDir/dotsFound
dotFiles=$logDir/dotFiles
a='[[:alpha:]]\w*\.'

cat <<EOF

#############################################################################
# $dotsFound
#############################################################################

EOF

fj |\
 xargs grep "$a$a$a" |\
 fgrep -v 'import ' |\
 fgrep -v 'package ' |\
 tee $dotsFound

cat <<EOF

#############################################################################
# $dotFiles
#############################################################################

EOF
 cut -d: -f1 $dotsFound | sort -u | tee $dotFiles

cat <<EOF

#############################################################################
# $dotPats
#############################################################################

EOF
 cut -d: -f2- $dotsFound | tee $dotPats


rmdir $logDir > /dev/null 2>&1
