#!/bin/bash

# jin='java Jindent -p C:\\p\\Jindent\\DeluxeSun-Style-doc.jin -unix -nobak'
JINDENTHOME="${SYSTEMDRIVE}\\p\\Jindent\\"

Style=" ${JINDENTHOME}DeluxeSun-Style-doc.jin "
[[ "$(basename $0)" = "big" ]] && Style=" ${JINDENTHOME}BigDeluxeSun-Style-doc.jin "

cat <<EOF

    #############################################################################
    # $Id: jindentDir.sh,v 1.3 2006/05/30 15:10:39 fboller Exp $
    # jindent files.  Style: $Style
    #############################################################################

EOF

jinCmd="java -cp ${JINDENTHOME}Jindent.jar Jindent -p $Style "
kount=0

(( $# == 0 )) && myArgs="*" || myArgs=$*;

# process java files
unixFiles=($(find $myArgs -type f -iname "*.java" | sort -u));
javaFiles=($(for arg in ${unixFiles[@]}; do cygpath -w $arg | sed -e "s/\\/\\\\/g"; done));
[[ -f $javaFiles ]] && (
    kount=$((kount=$kount+1))

    movePackageToTop.sh ${unixFiles[@]};
    printf "    %3d: " $kount
    echo ${javaFiles[@]} | xargs -n 20 -t $jinCmd -mm -nobak;
    movePackageToTop.sh ${unixFiles[@]};
)
