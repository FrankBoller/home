#!/bin/bash

cat <<EOF

#############################################################################
# $Id: expandFiles.sh,v 1.2 2005/09/01 17:31:12 fboller Exp $
#############################################################################

EOF

tmpFile=$$.1

for arg in $*
do
    echo "expand $arg"
    expand --tabs=4 $arg > $tmpFile
    mv $tmpFile $arg
done
