#!/bin/bash
# $Id: i2.sh,v 1.2 2005/09/01 17:31:12 fboller Exp $
#############################################################################

dest=$(pwd)
bn=$(basename $1 .sh)
baseDir=$(echo $dest | sed "s,/[^/]*/,/${bn}/,")

if [ -d $baseDir ] ; then
  pushd $baseDir > /dev/null
  dirs -v
else
  baseDir=$(echo $baseDir | sed 's,icjis_da_war,icjis_da.war,' )
  if [ -d $baseDir ] ; then
    pushd $baseDir > /dev/null
    dirs -v
  fi
fi
