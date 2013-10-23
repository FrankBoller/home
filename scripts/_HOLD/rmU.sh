#!/bin/bash

cat <<EOF

#############################################################################
# $Id: rmU.sh,v 1.2 2005/09/01 17:31:13 fboller Exp $
# remove U files
#############################################################################

EOF

REPLY=n

for arg in $(cvs -nq up | grep '^U' | cut -c3-)
do
    echo -n "remove <$arg> ? ([n]/y/A(ll)/q):"

    if [ "$REPLY" != "A" ] ; then
        read;
    fi

    if [ "$REPLY" = "q" ] ; then
        exit
    fi

    if [ "$REPLY" != "n" ] ; then
        echo ""
        echo "  rm -f $arg "
        echo "  cvs remove $arg "
        echo "  cvs ci -m removed $arg "
        rm -f $arg ; cvs remove $arg ; cvs ci -m removed $arg;
    fi
done
