#!/bin/bash
# $Id: cvt.sh,v 1.2 2005/10/21 02:06:47 fboller Exp $
#############################################################################

convert -geometry 32x32 $1 $1.png
png2ico $1.ico $1.png
rm -f $1.png
