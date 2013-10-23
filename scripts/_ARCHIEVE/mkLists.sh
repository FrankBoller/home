#!/bin/bash
# $Id: mkLists.sh,v 1.3 2005/09/20 20:23:54 fboller Exp $
#############################################################################

cmdLst="f2 finc fj fjs fjsp ftld fx"

for arg in $cmdLst
do
  echo "### $arg"
  if [ -e $arg.lst ] ; then save $arg.lst; fi
  ( eval $arg > $arg.lst ) && echo "finished $arg" || echo "failed $arg" ;
done

if [ -e f2.lst ] 
then
  fgrep .jar f2.lst > fa.lst
fi
