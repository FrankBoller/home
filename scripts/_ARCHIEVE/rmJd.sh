#!/bin/bash
id='$Id: rmJd.sh,v 1.8 2006/04/22 19:11:00 fboller Exp $'
cat <<EOF

#############################################################################
# ${id}
# jindent files
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

(( $# == 0 )) && myArgs='*' || myArgs=$*;

# process java files
unixFiles=($(find $myArgs -type f -iname '*.java' | sort -u));
javaFiles=($(for arg in ${unixFiles[@]}; do cygpath -w $arg | sed -e 's/\\/\\\\/g'; done));
[[ -f $javaFiles ]] && (
    for arg in ${unixFiles[@]}
    do
        echo ~/scripts/rmJd.gawk $arg
        gawk -f ~/scripts/rmJd.gawk < $arg > $logFile
        cat $logFile > $arg
    done
    rm -f $logFile
)
rmdir $logDir > /dev/null 2>&1
