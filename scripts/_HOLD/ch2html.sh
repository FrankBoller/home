#!/bin/bash

cat <<EOF

#############################################################################
# $Id: ch2html.sh,v 1.2 2005/09/01 17:31:12 fboller Exp $
#############################################################################

EOF

here=$PWD

for txtFile in *.txt
do
    cd $here
    cat <<EOF
#############################################################################
# $here $txtFile
#############################################################################
EOF
    bn=$(basename $txtFile .txt)
    subdir=sub.$bn
    mkdir -p $subdir
    cd $subdir
    pwd

    ##########################################################################
    # create htm files from txt files
    ##########################################################################

    csplit -f htm. ../${bn}.txt '/^<\/HTML>/+1' '{*}'

    for htm in htm.*
    do
        titleLine=$(fgrep '<TITLE>' $htm | head -1)
        title=$(echo $titleLine | sed -e 's/<\/TITLE>.*//g' -e 's/.*<TITLE>//g')
        echo "process $bn $htm $title"
        # mv $htm $title
    done
done
