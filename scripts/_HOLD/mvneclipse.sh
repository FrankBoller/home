#!/bin/bash
id='$Id: mvneclipse.sh,v 1.7 2007/08/10 15:09:51 fboller Exp $'
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
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
clean=
pomFile="-f pom.xml";
#################################

typeset -i E_OPTERR=0

options="cef:hnl:x"
while getopts $options Option
do
  case $Option in
    c) clean=eclipse:clean; mvn ${pomFile} ${clean};;
    e) exit;;
    f) pomFile="-f $OPTARG";;
    h) E_OPTERR=65; break;;
    l) logFile=$OPTARG;;
    n) MVN_OPTIONS="${MVN_OPTIONS} -npu -o "      ;;
    x) set -x;;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
    c) clean=eclipse:clean; mvn ${d}{pomFile} ${d}{clean};;
    e) exit;;
    f) pomFile="-f ${d}OPTARG";;
    h) E_OPTERR=65; break;;
    l) logFile=${d}OPTARG;;
    n) MVN_OPTIONS="${d}{MVN_OPTIONS} -npu -o "      ;;
    x) set -x;;
    
    $(printf "%11.11s = %-6s\n" logFile                     "${logFile}"     )
    $(printf "%11.11s = %-6s\n" pomFile                     "${pomFile}"     )
    $(printf "%11.11s = %-6s\n" MVN_OPTIONS                 "${MVN_OPTIONS}" )
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

set -x
mvn $* ${pomFile} ${clean} eclipse:eclipse -DdownloadSources=true
set +x

# rmdir $logDir > /dev/null 2>&1
