#!/bin/bash
id='$Id: job.sh,v 1.8 2006/04/22 19:10:59 fboller Exp $'
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

set +vx

dateFmt='+%Y-%m-%dT%H.%M.%S%z'
basename=$(basename $0 .sh)
# iso8601=$(date --iso-8601=seconds)
fileDate=$(date $dateFmt)
idRef=${basename}.${fileDate}

valueStatus="progress"
commandArgs=$*
commandFile=$0
commandLog=${idRef}_output.log
d='$'
dirname=$(dirname $0)
element="message"
fileName=
messageText="unknown"
eXitCode=""

sleep 1

typeset -i E_OPTERR=0

options="0a:c:e:f:hi:l:m:pv:x"
while getopts $options Option
do
  case $Option in
    0) fileName="stdin";;
    a) commandArgs=$OPTARG;;
    c) commandFile=$OPTARG;;
    d) dirname=$OPTARG; if [ "$dirname" = "." ] ; then dirname=$(pwd); fi;;
    e) element=$OPTARG;;
    f) fileName="$OPTARG";;
    h) E_OPTERR=65; break;;
    i) idRef=$OPTARG; . $idRef;;
    l) commandLog=$dirname/${idRef}_output.log;;
    m) messageText=$OPTARG;;
    v) valueStatus=$OPTARG;;
    x) eXitCode=$E_OPTERR;;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

if [ "$dirname" = "." ] ; then dirname=$(pwd); fi

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  <Usage> $0 -[$options]
    0 fileName="stdin"
    a commandArgs=${d}OPTARG
    c commandFile=${d}OPTARG
    e element=${d}OPTARG
    f fileName="${d}OPTARG"
    h displays (this) Usage
    i idRef=${d}OPTARG: . $idRef
    l commandLog=${d}OPTARG
    m messageText=${d}OPTARG
    v valueStatus=${d}OPTARG
    x eXitCode=${d}E_OPTERR

    basename             : $basename
    commandArgs          : $commandArgs
    commandFile          : $commandFile
    commandLog           : $commandLog
    dirname              : $dirname
    eXitCode             : $eXitCode
    element              : $element
    fileDate             : $fileDate
    fileName             : $fileName
    idRef                : $idRef
    messageText          : $messageText
    valueStatus          : $valueStatus
  </Usage>
EOF
  exit $E_OPTERR
fi

#############################################################################
# if first pass, output header
#############################################################################

tmpIdRef=$logDir/$idRef.sh

if [ ! -e $tmpIdRef ] ; then
  cat > $tmpIdRef <<EOF
  commandLog=$commandLog
  dirname=$dirname
EOF

  chmod a+rwx $tmpIdRef

  tee -a $commandLog <<EOF
  <job host="$(hostname)">
    <time start="$fileDate" />
    <command>
      <file>$commandFile</file>
      <args>$commandArgs</args>
    </command>
    <log file="$commandLog" />
EOF
#
#  #############################################################################
#  # if last pass, output trailer
#  #############################################################################
#
#elif [ -n "$eXitCode" ] ; then
#  . $tmpIdRef
#
#  if [ "eXitCode" = "0" ] ; then
#    statusText="success"
#  else
#    statusText="error"
#  fi
#
#  tee -a $commandLog <<EOF
#  <message status="$statusText">
#    E_OPTERR=$eXitCode
#  </message>
#  <time stop="$(date $dateFmt)" />
#</job>
#EOF
#
#  #############################################################################
#  # else, output element, status=valueStatus, timestamp, and text
#  #############################################################################
#
#else
#  . $tmpIdRef
#
#  if [ "$fileName" = "stdin" ]; then
#    tee -a $commandLog <<EOF
#    <$element status="$valueStatus" time="$(date $dateFmt)" >
#      $(cat)
#    </$element>
#EOF
#  else if [ -n "$fileName" ]; then
#    tee -a $commandLog <<EOF
#    <$element status="$valueStatus" time="$(date $dateFmt)" >
#      $(cat < $fileName)
#    </$element>
#EOF
#  else
#    tee -a $commandLog <<EOF
#    <$element status="$valueStatus" time="$(date $dateFmt)" text="$messageText" />
#EOF
#  fi
fi
rmdir $logDir > /dev/null 2>&1
