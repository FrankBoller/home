#!/bin/bash

cat <<EOF

#############################################################################
# $Id: mkPackage.sh,v 1.2 2005/09/01 17:31:13 fboller Exp $
# create javaDoc.package.lst
#############################################################################

EOF

find $* -iname '*.java' \
    | sed 's;^\./;;' \
    | sed 's,/[^/]*$,,' \
    | fgrep -v /dev/ \
    | sort -u \
    | sed 's,/,.,g' \
    > javaDoc.package.lst

cat javaDoc.package.lst
