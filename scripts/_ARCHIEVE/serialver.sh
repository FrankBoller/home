#!/bin/bash
id='$Id: serialver.sh,v 1.7 2006/04/22 19:11:01 fboller Exp $'
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

classpath=.
classpath="${classpath};${MAVEN_REPO}/axis/jars/axis-1.1.jar"
classpath="${classpath};${MAVEN_REPO}/axis/jars/jaxrpc-1.1.jar"
classpath="${classpath};${MAVEN_REPO}/axis/jars/saaj-1.1.jar"
classpath="${classpath};${MAVEN_REPO}/log4j/jars/log4j-1.2.8.jar"
classpath="${classpath};${MAVEN_REPO}/wsdl4j/jars/wsdl4j-1.4.jar"
classpath="${classpath};${MAVEN_REPO}/axis/jars/axis-ant-1.1.jar"
classpath="${classpath};${MAVEN_REPO}/axis/jars/commons-logging-1.1.jar"
classpath="${classpath};${MAVEN_REPO}/axis/jars/commons-discovery-1.1.jar"

typeset -i E_OPTERR=0

options="chl:"
while getopts $options Option
do
  case $Option in
    c) classpath="${OPTARG}"; break;;
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

for arg in $*; do
  serialver -classpath "${classpath}" $(echo $arg | sed -e 's;/;.;g' -e 's;.class;;') 2>&1 | tee -a ${logFile}
done

echo "logFile: ${logFile}"
rmdir $logDir > /dev/null 2>&1
