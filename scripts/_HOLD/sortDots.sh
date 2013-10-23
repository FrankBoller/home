#!/bin/bash
id='$Id: sortDots.sh,v 1.4 2006/10/02 14:26:52 fboller Exp $'
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
#################################


sep=$(echo -n a | tr a '\100')

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

echo ${*} \
  | sed -e "s;[.][[:digit:]];${sep}&;g" \
  | tr '[[:space:]]' '\n' \
  | sort \
  | tr -d ${sep}

# rmdir $logDir > /dev/null 2>&1
