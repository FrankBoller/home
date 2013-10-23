#!/bin/bash
id='$Id: newzip.sh,v 1.3 2006/10/02 14:26:52 fboller Exp $'
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
zipfile=${bn}.zip
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"
#################################

typeset -i E_OPTERR=0

options="hl:z:"
while getopts $options Option
do
  case $Option in
    h) E_OPTERR=65; break;;
    l) logFile=$OPTARG;;
    z) zipfile=$OPTARG;;
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
    z) $(printf "%11.11s = %-6s : [%s]\n" zipfile    $zipfile     '$OPTARG' )
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

zip ${zipfile} $(find . -daystart -mtime 0 -type f | fgrep -v CVS | xargs ls -t)

# rmdir $logDir > /dev/null 2>&1
