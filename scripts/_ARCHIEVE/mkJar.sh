#!/bin/bash

cat <<EOF

#############################################################################
# $Id: mkJar.sh,v 1.2 2005/09/01 17:31:13 fboller Exp $
# create com.deluxe.jdailies Jar file
#############################################################################

EOF

dateNow=$(date +%Y.%m.%d.%H%M)

# export developerNames=( frank jim kavita marc shahid )
export developerNames=( frank jim kavita marc )

for arg in  "${developerNames[@]}"
do
	jar cf com.deluxe.jdailies.$arg.$dateNow.jar $(find $* -iname '*.java' | sed 's;^\./;;' | fgrep "/${arg}/")
	echo $arg
done

