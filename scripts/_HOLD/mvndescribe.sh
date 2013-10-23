#!/bin/bash
id='$Id: mvndescribe.sh,v 1.2 2007/05/15 16:14:05 fboller Exp $'
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
#################################
plugin=
groupId=
artifactId=
version=
full=
#############################################################################

typeset -i E_OPTERR=0

options="a:fg:hl:p:v:"
while getopts $options Option
do
  case $Option in
    a) artifactId="-DartifactId=${OPTARG}";;
    f) full="-Dfull=true";;
    g) groupId="-DgroupId=${OPTARG}";;
    h) E_OPTERR=65; break;;
    l) logFile=$OPTARG;;
    p) plugin="-Dplugin=${OPTARG}";;
    v) version="-Dversion=${OPTARG}";;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
    a) artifactId=OPTARG;;
    f) full="-Dfull=true";;
    g) groupId=OPTARG;;
    h) displays (this) Usage
    l) logFile=OPTARG;;
    p) plugin=OPTARG;;
    v) version=OPTARG;;
    
    $(printf "%11.11s = %-6s\n" artifactId $artifactId )
    $(printf "%11.11s = %-6s\n" full       $full    )
    $(printf "%11.11s = %-6s\n" groupId    $groupId    )
    $(printf "%11.11s = %-6s\n" plugin     $plugin     )
    $(printf "%11.11s = %-6s\n" version    $version    )
    $(printf "%11.11s = %-6s\n" logFile    $logFile    )
EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

# mvn help:describe -Dplugin=org.somewhere:some-plugin:0.0.0
# mvn help:describe -Dplugin=help

set -x
  mvn help:describe ${plugin} ${artifactId} ${groupId} ${version} ${full} | tee ${logFile}
set +x

# rmdir $logDir > /dev/null 2>&1
