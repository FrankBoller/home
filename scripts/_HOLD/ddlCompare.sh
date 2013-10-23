#!/bin/bash
id='$Id: ddlCompare.sh,v 1.1 2007/07/09 16:34:13 fboller Exp $'
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
mkdir -p $logDir
logFile="${logDir}/logFile.log"
################################
sqlFile1=$1
sqlFile2=$2

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

#aArgs=( $* )
#if [ ${#aArgs[@]} != 2  ]; do
#  E_OPTERR=65
#else
#  if [ "$(basename ${sqlFile1} .sql)" == "${sqlFile1}" ] ; then
#    E_OPTERR=65
#  elif [ "$(basename ${sqlFile2} .sql)" == "${sqlFile2}" ] ; then
#    E_OPTERR=65
#  fi
#done

if [ $E_OPTERR != 0 ]
then
  #  cat <<EOF
  #  Usage $0 -[$options] some.ddl.sql a.different.ddl.sql
  #
  #  h displays (this) Usage
  #
  #  $(printf "%11.11s = %-6s\n" logFile    $logFile     )
  #EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

# rmdir $logDir > /dev/null 2>&1

for arg in ${sqlFile1} ${sqlFile2} ; do
  dos2unix ${arg}
  outfile=${arg}.sort.txt
  echo "${arg} to ${outfile}"

  tr '\n' ' ' < ${arg} \
  | sed \
  -e 's/18, 0/18/g' \
  -e 's/;/ ;\n /g' \
  | sed \
  -e 's/^\W\W*\(\w*\)\W\W*/\1 /g' \
  -e 's/^COMMENT.*//' \
  | tr -s ' ' \
  | sort -u \
  | sed -e 's/\(CREATE.*\) [)] /\1\n)/g' \
  | sed -e 's/,/\n  ,/g' \
  | sed -e 's/\(CREATE.*\) [(] /\1(\n   /g' \
  > ${outfile}
done



