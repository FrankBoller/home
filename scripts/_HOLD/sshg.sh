#!/bin/bash
id='$Id: sshg.sh,v 1.1 2012/01/30 22:05:27 bollf003 Exp $'
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
d='$'
currentDateTime=$(date +%Y.%m%d.%H%M)
logDir="${HOME}/tmp/logDir/${bn}/${currentDateTime}"
mkdir -p $logDir
logFile="${logDir}/logFile.log"
sshgCmd=
#################################

typeset -i E_OPTERR=0

options="c:hl:"
while getopts $options Option
do
  case $Option in
    c) sshgCmd=$OPTARG;;
    h) E_OPTERR=65; break;;
    l) logFile=$OPTARG;;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

test -z "${sshgCmd}" && E_OPTERR=-1;
test -z "${sshgCmd}" && echo "";

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
    c sshgCmd=${d}OPTARG
    h displays (this) Usage
    l logFile=${d}OPTARG
    
    $(printf "%17.17s = %-6s\n" logFile    $logFile     )
    $(printf "%17.17s = %-6s\n" sshgCmd    $sshgCmd     )
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

DEV1=bollf003@pl-ohco-dvvm003.idmzswna.idmz.disney.com
DEV2=bollf003@pl-ohco-dvvm004.idmzswna.idmz.disney.com
PROTO=bollf003@di-flor-lbd0d8c.wdw.disney.com
QA1A=bollf003@pl-ohco-qa001.idmzswna.idmz.disney.com
QA1B=bollf003@pl-ohco-qa002.idmzswna.idmz.disney.com
QA2=bollf003@pl-ohco-qavm001.idmzswna.idmz.disney.com

scpmServers=( DEV1 DEV2 PROTO QA1A QA1B QA2 )

cat <<EOF > ${logFile}
###
# ${id}
###

EOF

for arg in ${scpmServers[@]}; do
  eval userHostname=${d}${arg}

  cat <<EOF | tee -a ${logFile}

  ${arg}:   ${sshgCmd}
  $(ssh ${userHostname} ${sshgCmd} )

EOF
# Fun4Java3

done

ls -ladt ${logFile}
