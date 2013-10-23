#!/bin/bash
id='$Id: wm.sh,v 1.6 2007/08/11 00:37:56 fboller Exp $'
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
logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

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
    
    l) $(printf "%11.11s = %-6s : [%s]\n" logFile    $logFile     '$OPTARG' )
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

file1=$(cygpath -aml "$1")
file2=$(cygpath -aml "$2")

# ${SYSTEMDRIVE}\\Program Files\\WinMerge-2.4.8-exe\\WinMergeU.exe" ${file1} ${file2}
# /.programFiles/WinMerge-2.4.8-exe/WinMergeU.exe ${file1} ${file2}
nohup /.programFiles/WinMerge/WinMergeU.exe -r ${file1} ${file2} > /dev/null 2>&1 &

# rmdir $logDir > /dev/null 2>&1
