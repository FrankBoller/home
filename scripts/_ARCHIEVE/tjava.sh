#!/bin/bash

cat <<EOF

#############################################################################
# $Id: tjava.sh,v 1.2 2005/09/01 17:31:13 fboller Exp $
# test java
#############################################################################

EOF

package=$(echo $PWD | sed 's,^/c/tmp/vaProjects/,,')
hereFiles=($*);

[[ -f $hereFiles || -f ${hereFiles[0]}.java ]] && (
    jclass=$(basename ${hereFiles[0]} .java)
    hereFiles[0]=""
    shift

    if [ -f "$jclass.java" ] ; then
        package=$(grep '^package ' $jclass.java)
        package=$(echo $package | sed 's/package *\(.*\);/\1/')
    fi

#    echo "@= java ${package}/$jclass${hereFiles[@]}"
#    java ${package}/$jclass ${hereFiles[@]}

#    echo "*= java ${package}/$jclass${hereFiles[*]}"
#    java ${package}/$jclass ${hereFiles[*]}

#    echo ${hereFiles[@]} | xargs -i, echo '","'
#    echo ${hereFiles[*]} | xargs -i, echo "','"
#    echo $* | xargs -i, echo "','"

#    echo "###############################"

    echo java ${package}/$jclass $*
    java ${package}/$jclass $*
)
