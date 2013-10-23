#!/bin/bash
id='$Id: archetypeCreateMvn.sh,v 1.1 2007/08/01 23:16:40 fboller Exp $'
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

groupId=aDeleteGroup
projectId="project$$"

bn=$(basename $0 .sh)
# logDir="${HOME}/tmp/logDir/${bn}/$(now.sh)"
# mkdir -p $logDir
# logFile="${logDir}/logFile.log"

archetypeGroupId=org.appfuse
archetypeVersion=
remoteRepositories="http://static.appfuse.org/repository"
#################################

typeset -i E_OPTERR=0

options="a:A:G:JSTV:Zcg:hjl:p:stvxz"
while getopts $options Option
do
  case $Option in
    A) archetypeArtifactId=$OPTARG;;
    G) archetypeGroupId=$OPTARG;;
    J) bn=archetypeMjsf;;
    S) bn=archetypeMspring;;
    T) bn=archetypeMtapestry;;
    V) archetypeVersion=$OPTARG;;
    Z) bn=archetypeStruts;;
    a) artifactId=$OPTARG;;
    c) bn=archetypeCore;;
    g) groupId=$OPTARG;;
    h) E_OPTERR=65; break;;
    j) bn=archetypeJsf;;
    l) logFile=$OPTARG;;
    p) projectId=$OPTARG;;
    s) bn=archetypeSpring;;
    t) bn=archetypeTapestry;;
    v) bn=archetypeMstruts;;
    x) set -x;;
    z) bn=archetypeMstruts;;
    *) E_OPTERR=-1; echo "Unimplemented option chosen: $Option"; break;;
  esac
done

# Move argument pointer to next.
shift $(($OPTIND - 1))

if [ "$bn" = "archetypeCore" ] ; then archetypeArtifactId=appfuse-core
elif [ "$bn" = "archetypeJsf" ] ; then archetypeArtifactId=appfuse-basic-jsf
elif [ "$bn" = "archetypeMjsf" ] ; then archetypeArtifactId=appfuse-modular-jsf
elif [ "$bn" = "archetypeMspring" ] ; then archetypeArtifactId=appfuse-modular-spring
elif [ "$bn" = "archetypeMstruts" ] ; then archetypeArtifactId=appfuse-modular-struts
elif [ "$bn" = "archetypeMtapestry" ] ; then archetypeArtifactId=appfuse-modular-tapestry
elif [ "$bn" = "archetypeSpring" ] ; then archetypeArtifactId=appfuse-basic-spring
elif [ "$bn" = "archetypeStruts" ] ; then archetypeArtifactId=appfuse-basic-struts
elif [ "$bn" = "archetypeTapestry" ] ; then archetypeArtifactId=appfuse-basic-tapestry
else
  echo "no such $bn"
  E_OPTERR=65
fi

if [ $E_OPTERR != 0 ]
then
  cat <<EOF
  Usage $0 -[$options]
    A) archetypeArtifactId=${d}OPTARG;;
    G) archetypeGroupId   =${d}OPTARG;;
    J) bn                 =archetypeMjsf;;
    S) bn                 =archetypeMspring;;
    T) bn                 =archetypeMtapestry;;
    V) archetypeVersion   =${d}OPTARG;;
    Z) bn                 =archetypeStruts;;
    a) artifactId         =${d}OPTARG;;
    c) bn                 =archetypeCore;;
    g) groupId            =${d}OPTARG;;
    h) E_OPTERR           =65; break;;
    j) bn                 =archetypeJsf;;
    l) logFile            =${d}OPTARG;;
    p) projectId          =${d}OPTARG;;
    s) bn                 =archetypeSpring;;
    t) bn                 =archetypeTapestry;;
    v) bn                 =archetypeMstruts;;
    x) set -x;;
    z) bn                 =archetypeMstruts;;

  $(printf "%30.30s = %-6s \n" archetypeArtifactId $archetypeArtifactId)
  $(printf "%30.30s = %-6s \n" archetypeGroupId    $archetypeGroupId   )
  $(printf "%30.30s = %-6s \n" archetypeVersion    $archetypeVersion   )
  $(printf "%30.30s = %-6s \n" artifactId          $artifactId         )
  $(printf "%30.30s = %-6s \n" bn                  $bn                 )
  $(printf "%30.30s = %-6s \n" groupId             $groupId            )
  $(printf "%30.30s = %-6s \n" logFile             $logFile            )
  $(printf "%30.30s = %-6s \n" projectId           $projectId          )
  $(printf "%30.30s = %-6s \n" remoteRepositories  $remoteRepositories )

  mvn archetype:create                           \\
    -DarchetypeGroupId=${archetypeGroupId}       \\
    -DarchetypeArtifactId=${archetypeArtifactId} \\
    -DremoteRepositories=${remoteRepositories}   \\
    -DarchetypeVersion=${archetypeVersion}       \\
    -DgroupId=${groupId}                         \\
    -DartifactId=${projectId}

  mvn archetype:create -DgroupId=${groupId} -DartifactId=${projectId}

  mvn archetype:create -DgroupId=${groupId} -DartifactId=${projectId} -DarchetypeArtifactId=maven-archetype-quickstart

Index of /pub/mirrors/maven2/org/apache/maven/archetypes:

maven-archetype-archetype
maven-archetype-bundles
maven-archetype-j2ee-simple
maven-archetype-marmalade-mojo
maven-archetype-mojo
maven-archetype-plugin-site
maven-archetype-plugin
maven-archetype-portlet
maven-archetype-profiles
maven-archetype-quickstart
maven-archetype-simple
maven-archetype-site-simple
maven-archetype-site
maven-archetype-webapp

EOF
  echo "failed: $E_OPTERR"
  exit $E_OPTERR
fi

#############################################################################

# mvn archetype:create -DgroupId=${projectId} -DartifactId=${projectId}

set -x

mvn archetype:create  \
-DarchetypeGroupId=${archetypeGroupId}  \
-DarchetypeArtifactId=${archetypeArtifactId} \
-DremoteRepositories=${remoteRepositories}  \
-DarchetypeVersion=${archetypeVersion}  \
-DgroupId=${groupId}  \
-DartifactId=${projectId} \
$*

set +x
