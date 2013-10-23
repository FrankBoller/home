#!/bin/bash
id='$Id: mvnInstallFile.sh,v 1.1 2007/08/01 23:16:40 fboller Exp $'
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

file=
groupId=groupId
artifactId=
version="1.0-SNAPSHOT"
packaging="jar"

typeset -i E_OPTERR=0

options="a:f:g:hl:p:v:"
while getopts $options Option
do
  case $Option in
    a) artifactId=$OPTARG;;
    f) file=$OPTARG;;
    g) groupId=$OPTARG;;
    h) E_OPTERR=65; break;;
    l) logFile=$OPTARG;;
    p) packaging=$OPTARG;;
    v) version=$OPTARG;;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

if [ x"${artifactId}" = x ]  ; then E_OPTERR=65 ; echo "# ERROR: file (${artifactId}) must artifactId"    ; fi
if [ x"${file}" = x ]  ; then E_OPTERR=65 ; echo "# ERROR: file (${file}) must exist"    ; fi

# Move argument pointer to next.
shift $(($OPTIND - 1))

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
    h displays (this) Usage
    a) artifactId=${d}OPTARG;;
    f) file=${d}OPTARG;;
    g) groupId=${d}OPTARG;;
    h) E_OPTERR=65; break;;
    l) logFile=${d}OPTARG;;
    p) packaging=${d}OPTARG;;
    v) version=${d}OPTARG;;
    
    $(printf "%11.11s = %-6s\n" file       $file )
    $(printf "%11.11s = %-6s\n" artifactId $artifactId )
    $(printf "%11.11s = %-6s\n" groupId    $groupId    )
    $(printf "%11.11s = %-6s\n" logFile    $logFile    )
    $(printf "%11.11s = %-6s\n" packaging  $packaging  )
    $(printf "%11.11s = %-6s\n" version    $version    )

    mvn install:install-file    \\
      -DgeneratePom=true        \\
      -DrepositoryLayouts=true  \\
      -Dfile=${file}            \\
      -DgroupId=${groupId}      \\
      -DartifactId=${artifactId}\\
      -Dversion=${version}      \\
      -Dpackaging=${packaging}

EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

set -x
mvn install:install-file     \
  -DgeneratePom=true         \
  -DrepositoryLayouts=true   \
  -DcreateChecksum=true      \
  -Dfile=${file}             \
  -DgroupId=${groupId}       \
  -DartifactId=${artifactId} \
  -Dversion=${version}       \
  -Dpackaging=${packaging}
set +x


# rmdir $logDir > /dev/null 2>&1
