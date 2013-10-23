#!/bin/bash
# $Id: hitJin.sh,v 1.2 2005/09/01 17:31:12 fboller Exp $
#############################################################################

here=$PWD

for dir in $(find -type d -iname '?*' | sed 's,^\.\/,,')
do
    cd $here/$dir
    if [ $(find -maxdepth 1 -iname '*.java' | wc -l) -lt 1 ] ; then continue; fi

    echo ""
    echo "**** dir = **** $(pwd)"

    find -maxdepth 1 -iname '*.java' \
        | sed 's,^\.\/,,' \
        | xargs -n9 java Jindent \-p e:\\Hitplay-Style.jin \-auto \-bak
    echo ""

done


