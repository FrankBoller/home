#!/usr/bin/bash
# $Id: dateSave.sh,v 1.1 2005/02/04 01:56:56 fboller Exp $
#############################################################################

bn=$(basename $0 .sh)

for arg in $*
do
    # skip everything but a FILE match
    [[ -f $arg ]] || continue;

    baseName=$(baseName $arg)

    # skip .date. files
    [[ ${baseName:0:6} = ".date." ]] && continue;

    dirName=$(dirname $arg)
    dateName=${dirName}/.date.${baseName}

    case $bn in 

        "dateSave")
        {
            # do not overwrite existing .date. file
            [[ -f $dateName ]] && continue;
            echo "touch -r $arg $dateName"
            touch -r $arg $dateName
        };; 

        "dateRestore")
        {
            [[ -f $dateName ]] && touch -r $dateName $arg
        };; 

        *) 
        echo oops $bn unknown;; 
    esac 

done
