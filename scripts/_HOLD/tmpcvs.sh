#!/bin/bash
# $Id: tmpcvs.sh,v 1.1 2005/02/04 01:56:57 fboller Exp $
#############################################################################

here=$(pwd)
files=$*

cp $files ~/tmp

cd ~/tmp
cvs -q ci -m "wip" $files

cd $here
for arg in $files
do
  cp ~/tmp/$arg .
done
