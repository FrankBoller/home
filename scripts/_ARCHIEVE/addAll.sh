#!/bin/bash

cat <<EOF

#############################################################################
# $Id: addAll.sh,v 1.2 2005/09/01 17:31:12 fboller Exp $
# add CVS ? files 
#############################################################################

EOF

REPLY=n

for arg in $(cvs -nq up | sort | grep '^[?]' | cut -c3-)
do
    echo -n "add <$arg> ? ([n]/y/A(ll)/q):"

    if [ "$REPLY" != "A" ] ; then
        read;
    fi

    if [ "$REPLY" = "q" ] ; then
        exit
    fi

    if [ "$REPLY" != "n" ] ; then
        echo ""
        echo "  cvs add $arg "
        echo "  cvs -q ci -m \"initial import\" $arg "
        cvs add $arg ; cvs -q ci -m "initial import" $arg;
    fi
done
