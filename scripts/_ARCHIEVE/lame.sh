#!/bin/bash
id='$Id: lame.sh,v 1.7 2006/04/22 19:10:59 fboller Exp $'
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
logDir="/tmp/logDir/${bn}/$(now.sh)"
mkdir -p $logDir
logFile="${logDir}/logFile.log"
#################################

baseDir=$(basename $(pwd))
lame=/c/local/lame-3.97/frontend/lame.exe

typeset -i E_OPTERR=0

options="hl:"
while getopts $options Option
do
  case $Option in
    h) E_OPTERR=65; break;;
    l) logFile=$OPTARG;;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
    h displays (this) Usage
    l is the name of the logfile    : $logFile
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

logBn=${logDir}/${baseDir}.$$
inputWavList=${logBn}/inputWavList.lst

mkdir -p ${logBn}
find * -type f | fgrep -i .wav > $inputWavList
# cat $inputWavList
touch ${logFile}

while read f; do
  dn=$(dirname "$f")
  bname=$(basename "$f" .wav)
  destDir="${logBn}/${dn}"

  mkdir -p "${destDir}"

  echo -n "${f}: " | tee -a ${logFile}
  /usr/bin/time $lame --brief --preset standard -S "$f" "${destDir}/${bname}.mp3" 2>&1 | tee -a ${logFile}

done < $inputWavList
rmdir $logDir > /dev/null 2>&1
