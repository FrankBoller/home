#!/bin/bash
# $Source: e:\local\cvsHome/home/fboller/scripts/hl.sh,v $
id='$Id: hl.sh,v 1.14 2006/11/08 18:47:01 fboller Exp $'
# cat <<EOF
# 
# #############################################################################
# # ${id}
# # 
# #############################################################################
# 
# EOF

if [ -f ~/.aliases ] ; then
    shopt -s expand_aliases
    source ~/.aliases
fi

bn=$(basename $0 .sh)
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

# rm -f i.start i.md5sum.txt; touch i.start; touch i.md5sum.txt;  find /i -type f | xargs -L 10 md5sum >> i.md5sum.txt

base=/tmp/${bn}.$(basename $1)
echo ${base}

rm -f ${base}.start.txt ${base}.md5sum.txt
touch ${base}.start.txt ${base}.md5sum.txt

time find $1 -type f -print0 | xargs -0 -L 10 -i, md5sum , >> ${base}.md5sum.txt 

ls -lad ${base}.*
