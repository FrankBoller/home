#!/bin/bash
id='$Id: wsdl2java.sh,v 1.1 2007/01/28 22:37:42 fboller Exp $'
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
axisDir=c:/java/apache/axis-1_4

jarEcho=( ${axisDir}/lib/*.jar )
cp=$(echo "${jarEcho[*]}" | sed 's/[[:space:]]/;/g' )
#############################################################################

for arg in $* ; do
  dn=$(dirname $arg)
  lowerName=$(echo $arg | tr '[A-Z]' '[a-z]')
  bn=$(basename $lowerName)
  rootname=$(basename $lowerName .wsdl)
  if [ x"${bn}" == x"${rootname}" ] ; then continue ; fi

  set -x
  java -classpath "${cp}" org.apache.axis.wsdl.WSDL2Java $arg
  set +x
done

# rmdir $logDir > /dev/null 2>&1
