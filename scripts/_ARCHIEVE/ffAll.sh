#!/bin/bash
id='$Id: ffAll.sh,v 1.9 2006/04/22 19:10:58 fboller Exp $'
cat <<EOF

#############################################################################
# ${id}
# 
#############################################################################

EOF

if [ -f ~/.aliases ] ; then
    shopt -s expand_aliases
    source ~/.aliases
fi

bn=$(basename $0 .sh)
dn=$(basename $(pwd))
logDir="/tmp/logDir/${bn}/$(now.sh)"
mkdir -p $logDir
logFile="${logDir}/logFile.log"
#################################

inList=( \
  f2 \
  fb \
  fd \
  fdtd \
  fh \
  fimg \
  finc \
  fj \
  fjs \
  fjsp \
  fl \
  fm \
  fo \
  fp \
  fs \
  fsql \
  ft \
  ftld \
  fx \
  fxsd \
)


for cmd in ${inList[@]}; do echo $cmd;
  eval "${cmd} > ${logDir}/${cmd}.txt"
done

cd ${logDir}
find ${logDir} -type f -size 0 | xargs rm -f
rmdir $logDir > /dev/null 2>&1
