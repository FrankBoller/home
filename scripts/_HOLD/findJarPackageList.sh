#!/bin/bash
# $Id: findJarPackageList.sh,v 1.2 2005/09/01 17:31:12 fboller Exp $
#############################################################################

fileOut=jarPackage.txt
if [ -e $fileOut ] ; then
  mv $fileOut jarPackage.$(now).txt
fi
touch $fileOut

for arg in $(fa)
do
  echo "### $arg"

  jar tf $arg \
    | fgrep . \
    | sed 's;/[^/][^/]*$;;' \
    | fgrep -v META-INF \
    | sort -u \
    | sed "s;^;${arg}: ;" \
  >> $fileOut

done
