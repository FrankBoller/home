#!/usr/bin/bash
# $Id: save.sh,v 1.2 2005/03/25 00:14:19 fboller Exp $
#############################################################################

dateNow=$(date +%Y.%m.%d.%H%M)

for arg in $*
do
  cp $arg $arg.$dateNow
  touch -r $arg $arg.$dateNow
  echo $arg.$dateNow
done

