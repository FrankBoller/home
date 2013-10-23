#!/bin/bash
id='$Id: xml2xsd.sh,v 1.2 2006/11/27 19:44:44 fboller Exp $'
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
jingDir=c:/java/oss/jing-20030619/bin
trangDir=c:/java/oss/trang-20030619

# jarEcho=( ${trangDir}/*.jar ${jingDir}/*.jar )
jarEcho=( ${jingDir}/*.jar )
cp=$(echo ${jarEcho} | sed 's/[[:space:]]/;/g' )
#############################################################################

for arg in $* ; do
  dn=$(dirname $arg)
  lowerName=$(echo $arg | tr '[A-Z]' '[a-z]')
  bn=$(basename $lowerName)
  rootname=$(basename $lowerName .xml)
  if [ x"${bn}" == x"${rootname}" ] ; then continue ; fi

  set -x
  destname=$(echo ${arg} | sed -e 's/.xml//g' -e 's/.XML//g')
  java -classpath "${cp}" -jar ${trangDir}/trang.jar "${arg}" "${destname}.xsd"
  set +x
done


# rmdir $logDir > /dev/null 2>&1
