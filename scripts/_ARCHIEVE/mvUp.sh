#!/bin/bash

cat <<EOF

#############################################################################
# $Id: mvUp.sh,v 1.2 2005/09/01 17:31:13 fboller Exp $
# move files up to parent directory
#############################################################################

EOF

(( $# == 0 )) && (
    echo "usage: $0 name"
) || (
    here=$PWD
    echo process $1 files down from $here

    for arg in $(find * -type d | fgrep -v CVS | fgrep $1)
    do
        echo ""
        cd ${here}/$arg
        echo -n $arg 'mv *.java .. ? ([n]/y/q):'
        read

        if [ "$REPLY" = "q" ] ; then
            exit
        elif [ "$REPLY" = "y" ] ; then
            echo mv *.java ..
            mv *.java ..
        fi
    done

    cd ${here}
)
