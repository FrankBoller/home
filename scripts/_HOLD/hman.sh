#!/bin/bash
id='$Id: hman.sh,v 1.10 2006/10/02 14:26:51 fboller Exp $'
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
logDir="${HOME}/tmp/logDir/${bn}"
mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

for arg in $*
do
  htmlFile=$logDir/${arg}.html
  echo $htmlFile

#   if [ ! -f $htmlFile ]; then
#     inputFile=$(man -w $arg)
#     bnFile=$(basename $inputFile)
#     gzFile=$(basename $inputFile .gz)
# 
#     if [ ${gzFile}.gz = $bnFile ] ; then
#       zcat $inputFile | man2html > $htmlFile
#     else
#       man2html $inputFile > $htmlFile
#     fi
#   fi

  if [ ! -f $htmlFile ]; then
      man $arg | rman -f html > $htmlFile
  fi

  we $(cygpath -w $htmlFile)
done
rmdir $logDir > /dev/null 2>&1
