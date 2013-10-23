#!/bin/bash
# $Id: mkIcons.sh,v 1.1 2005/11/04 16:36:56 fboller Exp $
#############################################################################

set -x
for arg in $*; do
  convert -geometry 32x32 $arg $arg.png
  png2ico $arg.ico $arg.png
  rm -f $arg.png
done
set +vx
