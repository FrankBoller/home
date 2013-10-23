#!/bin/bash
# $Id: getJarPackages.sh,v 1.2 2006/01/27 02:02:00 fboller Exp $
#############################################################################

for arg in $(fa)
do
  echo "### $arg"
  jar tf $arg | fgrep .class | sed 's;/[^/]*$;;' | sort -u | xargs -i, echo "${arg}: " ,
done
