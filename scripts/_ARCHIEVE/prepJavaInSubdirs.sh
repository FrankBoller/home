#!/bin/bash

cat <<EOF

#############################################################################
# $Id: prepJavaInSubdirs.sh,v 1.2 2005/09/01 17:31:13 fboller Exp $
# walk directory tree and perform movePackageToTop
#############################################################################

EOF

hereDir=$PWD

find * -iname '*.java.*' | xargs rm -f

subDirs=($(find $hereDir -type d)); [[ -d $subDirs ]] && (

	for dirName in "${subDirs[@]}"
	do
	  cd $dirName
	  echo $dirName

	  hereFiles=(*.java); [[ -f $hereFiles ]] && (
		  movePackageToTop.sh *.java
	  )
	done

	cd $hereDir
)
