#!/bin/bash
# $Id: cdCatalog.sh,v 1.3 2005/09/01 17:31:12 fboller Exp $
#############################################################################

cdDate=$1

if [ $# == 1 ] ; then
    cdLabel=$(echo "#mp3_$1") 
elif [ $# == 2 ] ; then
    cdLabel="# $2"
else
    echo "usage $0 CD_date_like:19960509 non-spaced_CD_label_like: 000131_Ftp"
    exit
fi

cdDirs=$cdDate.dirs
cdFiles=$cdDate.files

dest=/c/tmp/cdCatalog
if [ ! -e $dest ] ; then
    mkdir -p $dest
fi
cd $dest

if [ -e "$cdFiles" ] ; then
    echo "*** ERROR: ALREADY EXISTS!!!"
    ls -lad $cdFiles
    exit
fi

echo "$cdLabel $cdDate" > $cdFiles

set -v

find /d/* ! -type d > $$
cut -c4- < $$ | sort >> $cdFiles
rm $$

sed 's,/[^/]*$,,' < $cdFiles | sort -u > $cdDirs

set +v
ls -la

